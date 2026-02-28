extends Node2D

@export var detras := false
@export var izquierda := true
var movimiento := false
var activado := false

@export var oficina: Node2D


signal Girar(izquierda: bool)
signal Girar_Input

func _on_oficina_movimiento(movement: bool) -> void:
	if detras:
		movimiento = false
		return
	if movement:
		movimiento = true
		activado = false
	else: 
		movimiento = false

func _on_area_2d_girar_mouse_entered() -> void:
	
	if detras == false:
		if oficina.camaras_activadas:
			return
		if oficina.tick_stop == true:
			return
	else:
		if oficina.stop_everything == true:
			return
	if activado == false:
		return
	if izquierda:
		Girar.emit(true)
	else:
		Girar.emit(false)

func _on_area_2d_pre_girar_mouse_entered() -> void:
	if movimiento:
		activado = false
	else:
		activado = true

func _input(event):
	if detras or izquierda == false: # el giro por imput solo lo controla el de delante derecha
		return
	if event.is_action_pressed("Girarse") and oficina.camaras_activadas == false and $"../..".tick_stop == false: # como a esta parte no pueden acceder los de detras no me preocupo
		Girar_Input.emit()


func _on_oficina_girar_input_permitido(izquierda_input: bool, detras_input: bool) -> void:
	if detras_input == false:
		Girar.emit(izquierda_input)


func _on_oficina_girando_estado(girando: int) -> void:
	if girando == 3 and oficina.camaras_activadas: # detras con las camaras, mal asunto
		Girar_Input.emit()
