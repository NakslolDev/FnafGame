extends Node2D

var linterna_activa_temporal := false

@export var linterna_discharch_speed := 0.3
@export var linterna_recharch_speed := 0.4
@export var linterna_penalty := 10
var did_click_on := false # funciona como un limiter pero para soltar el click
var linterna_recargando := false
var linterna_animacion_count := 0
signal Linterna_Activada_Switch()
signal Linterna_Recargando_Switch()

@export_group("Nodes")
@export var linternaPNG: Sprite2D
@export var linterna_press: AudioStreamPlayer
@export var linterna_release: AudioStreamPlayer
@export var linterna_animacion_timer: Timer
@onready var father: Node2D = get_parent()


var tick_rate: float

func _ready():
	Foxy.move_back.connect(foxy_animacion)
	set_process(true)
	# Aseguramos que el nodo ya existe y luego llamamos el setter
	set_linterna(linterna_activa_temporal)

func _process(_delta):
	
	global_position = get_global_mouse_position()
	
	if Global.linterna_bateria == 0:
		if linterna_activa_temporal:
			Linterna_Activada_Switch.emit()
			linterna_activa_temporal = false
			linternaPNG.modulate.a = 0.0


func set_linterna(value):
	linterna_activa_temporal = value
	if linterna_activa_temporal:
		linternaPNG.modulate.a = 0.3
		if Global.linterna_bateria <= linterna_penalty and Global.linterna_bateria > 1: #hace que si no te queda suficiente bateria pa encender, se queda a 1%
			Global.linterna_bateria = 1
		else:
			Global.linterna_bateria -= linterna_penalty # cuanto quita la linterna 
	else:
		linternaPNG.modulate.a = 0.0


func _input(event):
	if event.is_action_pressed("Click"):
		if linterna_recargando or father.camaras_activadas or linterna_animacion_count != 0 or father.tick_stop:
			return
		if _input_free():
			linterna_press.play()
			did_click_on = true
			set_linterna(!linterna_activa_temporal)
			Linterna_Activada_Switch.emit()
	
	if event.is_action_released("Click"):
		if linterna_recargando or father.camaras_activadas or linterna_animacion_count != 0 or father.tick_stop:
			return
		if did_click_on:
			linterna_release.play()
			did_click_on = false

func _input_free() -> bool:
	for area in get_tree().get_nodes_in_group("interactable"):
		for overlaping_areas in area.get_overlapping_areas():
			if str(overlaping_areas).begins_with("MouseHitbox"):
				print("Input taken: ", area)
				return false
	return true


func cams_up():
	if linterna_activa_temporal:
		set_linterna(!linterna_activa_temporal)
		Linterna_Activada_Switch.emit()
		did_click_on = false


func _on_timer_linterna_tic():
	if linterna_animacion_count == 0:
		Global.linterna_bateria -= 1

func _on_oficina_detras_linterna_recarga_switch_rebote() -> void:
	linterna_recargando = !linterna_recargando
	if linterna_activa_temporal:
		set_linterna(!linterna_activa_temporal)
		Linterna_Activada_Switch.emit()
	Linterna_Recargando_Switch.emit()

func _on_timer_recargar_linterna_tic_recarga() -> void:
	if Global.energia["Linterna"]:
		Global.linterna_bateria += 1


const ITERATIONS_ON_FOXY_ANIMATION := 9
func foxy_animacion():
	linterna_animacion(ITERATIONS_ON_FOXY_ANIMATION)

func linterna_animacion(value):
	linternaPNG.modulate.a = 0.0
	Linterna_Activada_Switch.emit()
	linterna_animacion_count = value
	linterna_animacion_timer.start(0.3 * 5.0 / tick_rate)

func _on_linterna_animacion_timeout() -> void:
	linterna_animacion_count -= 1
	Linterna_Activada_Switch.emit()
	if linternaPNG.modulate.a > 0.0:
		linternaPNG.modulate.a = 0.0
	else:
		linternaPNG.modulate.a = 0.3
	if linterna_animacion_count > 0:
		if linterna_animacion_count > 3:
			linterna_animacion_timer.start((0.1 * (linterna_animacion_count - 2) / 3.0) * 5.0 / tick_rate)
		elif linterna_animacion_count == 1:
			linterna_animacion_timer.start(0.3 * 5.0 / tick_rate)
		else:
			linterna_animacion_timer.start((0.1 * 3.0 / 4.0) * 5.0 / tick_rate)
		if linterna_animacion_count == 1:
			Foxy.move_back_to()
