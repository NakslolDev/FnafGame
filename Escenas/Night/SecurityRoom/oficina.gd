extends Node2D

# mover 240 hacia los lados como máximo
@export var movimiento_max := 240.0
@export var movimiento_max_girar := 7000
@export var VELOCIDAD_CAMERA: float = 300.0
@export var buttons_slow_down := false
var velocidad: float
var lock_tf_in := false
signal Movimiento(si: bool)
signal Girando_Señal(si: bool)
signal Girando_Estado(girando: int)
var girando := 0 # 1 derecha, 2 izquierda, - volviendo, 0 NO GIRANDO
signal Girar_Input_Permitido(izquierda: bool, detras: bool)
var last_giro_izquierda: bool
var giro_input_centro := false

#Para desconectar oficina detras
var desconectar_no_repetir := false
var oficina_detras_nodo: Node2D = null
var padre_original: Node = null

var cams_open := false

func _process(delta):
	
	if giro_input_centro:
		var target: Vector2
		if position.x > 0:
			target = Vector2(movimiento_max, 0.0)
		if position.x < 0:
			target = Vector2(-movimiento_max, 0.0)
		if position.x == 0:
			#get_tree().quit() # una pequeña bromita/easter_egg
			var random = randi() % 2 == 0
			if random:
				target = Vector2(movimiento_max, 0.0)
			else:
				target = Vector2(-movimiento_max, 0.0)
		position = position.move_toward(target, movimiento_max_girar * delta)
		if position == target:
			giro_input_centro = false
			_on_detector_girar_izquierda_girar_input()
		return
	
	emit_signal("Girando_Estado", girando)
	
	if girando == 0:
		Freddy.girado = false
	else:
		Freddy.girado = true
	
	#print("girando: ", girando, " Pos X: ", position.x)
	if girando == 1:
		Girando_Señal.emit(true)
		if position.x == -3120:
			girando = 3
			return
		var target = Vector2(-3120, 0)
		position = position.move_toward(target, movimiento_max_girar * delta)
		
	if girando == 2:
		Girando_Señal.emit(true)
		if position.x == 3120:
			girando = 3
			return
		var target = Vector2(3120, 0)
		position = position.move_toward(target, movimiento_max_girar * delta)
		
	if girando == -1 or girando == -2:
		Girando_Señal.emit(true)
		if position.x == 0:
			girando = 0
			return
		
		if desconectar_no_repetir:
			if girando == -1:
				_separar_oficina_detras_de_oficina(true)
			else:
				_separar_oficina_detras_de_oficina(false)
		
		var target = Vector2(0, 0)
		position = position.move_toward(target, movimiento_max_girar * delta)
	
	if girando != 0:
		return
	
	Girando_Señal.emit(false)
	
	var boton_slow_down = 1.0
	
	_get_velocity_from_mouse()
	
	if position.x >= movimiento_max and velocidad < 0:
		velocidad = 0
		
	if position.x <= -movimiento_max and velocidad > 0:
		velocidad = 0

	if velocidad == 0:
		Movimiento.emit(false)
	else:
		Movimiento.emit(true)
	
	if lock_tf_in and buttons_slow_down:
		boton_slow_down = 0.5
	
	position.x -= velocidad * delta * boton_slow_down
	
	if position.x > movimiento_max:
		position.x = movimiento_max
	if position.x < -movimiento_max:
		position.x = -movimiento_max


func _separar_oficina_detras_de_oficina(izquierda: bool):
	oficina_detras_nodo = $Oficina_Detras
	padre_original = oficina_detras_nodo.get_parent()
	
	# Guardamos posición global para evitar que se mueva
	var posicion_original = oficina_detras_nodo.global_position
	
	# 1. Desconectar de Oficina y moverlo al root
	padre_original.remove_child(oficina_detras_nodo)
	get_tree().get_root().add_child(oficina_detras_nodo)
	oficina_detras_nodo.global_position = posicion_original
	
	if izquierda:
		position.x = 3120
	else:
		position.x = -3120
	
	# 2. Reconectar a Oficina
	get_tree().get_root().remove_child(oficina_detras_nodo)
	padre_original.add_child(oficina_detras_nodo)
	oficina_detras_nodo.global_position = posicion_original
	
	desconectar_no_repetir = false

const MOVEMENT_MARGIN := 150.0
const MOVEMENT_MULTIPLYER := 2.5

func _get_velocity_from_mouse():
	if cams_open: return
	
	var mouse_pos: float = get_global_mouse_position().x
	
	var local_margin := MOVEMENT_MARGIN
	var local_multiplyer := MOVEMENT_MULTIPLYER
	
	if Input.is_action_pressed("Focus"):
		local_margin = 300
		local_multiplyer = 1.5
	
	if abs(mouse_pos) < local_margin:
		velocidad = 0 
	
	elif mouse_pos > 0:
		velocidad = (mouse_pos - local_margin) * local_multiplyer
	else:
		velocidad = (mouse_pos + local_margin) * local_multiplyer
	


func _on_boton_izquierda_mouse_entered_switch() -> void:
	lock_tf_in = !lock_tf_in

func _on_boton_derecha_mouse_entered_switch() -> void:
	lock_tf_in = !lock_tf_in


func _on_detector_girar_izquierda_girar(izquierda: bool) -> void:
	if giro_input_centro:
		return
	if girando == 0 or girando == 3:
		if izquierda:
			girando = 2
			last_giro_izquierda = true
		else:
			girando = 1
			last_giro_izquierda = false

func _on_oficina_detras_girar_detras(izquierda: bool) -> void:
	if giro_input_centro:
		return
	if girando == 0 or girando == 3:
		desconectar_no_repetir = true
		if izquierda:
			girando = -2
			last_giro_izquierda = true
		else:
			girando = -1
			last_giro_izquierda = false


func _on_detector_girar_izquierda_girar_input() -> void:
	
	const LEFT := true
	const RIGHT := false
	const LOOK_FORWARDS := false
	const LOOK_BACKWARDS := true
	
	if girando == 0:
		if position.x == movimiento_max:
			Girar_Input_Permitido.emit(LEFT, LOOK_FORWARDS)
		if position.x == -movimiento_max:
			Girar_Input_Permitido.emit(RIGHT, LOOK_FORWARDS)
		if position.x != movimiento_max and position.x != -movimiento_max:
			giro_input_centro = true
	if girando == 3:
		var random = randi() % 2 == 0
		if random:
			Girar_Input_Permitido.emit(LEFT, LOOK_BACKWARDS)

		else:
			Girar_Input_Permitido.emit(RIGHT, LOOK_BACKWARDS)
