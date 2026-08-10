extends Node2D

var linterna_activada := false

@export var hide_png: bool = false
@export var linterna_discharch_speed := 0.3
@export var linterna_recharch_speed := 0.4
@export var linterna_penalty := 5
var did_click_on := false # funciona como un limiter pero para soltar el click
var linterna_recargando := false
var linterna_animacion_count := 0
signal Linterna_Activada_Switch(on: bool, animation: bool)
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
	Foxy.cancel_move_back.connect(cancel_foxy_animation)
	set_linterna(false)

func _process(_delta: float) -> void:
	
	global_position = get_global_mouse_position()
	
	if Global.linterna_bateria == 0 and linterna_activada:
		set_linterna(false)


func set_linterna(value: bool, animation := false):
	linterna_activada = value
	Linterna_Activada_Switch.emit(value, linterna_animacion_count != 0)
	linternaPNG.visible = value and not hide_png

	if animation: # si esta haciendo la animacion
		return

	if linterna_activada:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Flashlight on")
		if Global.linterna_bateria <= linterna_penalty and Global.linterna_bateria > 1: #hace que si no te queda suficiente bateria pa encender, se queda a 1%
			Global.linterna_bateria = 1
		else:
			Global.linterna_bateria -= linterna_penalty # cuanto quita la linterna 
	else:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Flashlight off")


func _input(event):
	
	if event.is_action_pressed("Shift"):
		foxy_animacion()
	
	if event.is_action_pressed("Click"):
		if linterna_recargando or father.camaras_activadas or linterna_animacion_count != 0 or father.tick_stop:
			return
		if _input_free():
			linterna_press.play()
			did_click_on = true
			if Global.linterna_bateria != 0: set_linterna(!linterna_activada)
	
	if event.is_action_released("Click"):
		if linterna_recargando or father.camaras_activadas or linterna_animacion_count != 0 or father.tick_stop:
			return
		if did_click_on:
			linterna_release.play()
			did_click_on = false

func _input_free() -> bool:
	for area in get_tree().get_nodes_in_group("interactable"):
		for overlaping_areas in area.get_overlapping_areas():
			if overlaping_areas.name.begins_with("MouseHitbox"):
				#print("Input taken: ", area)
				return false
	return true


func cams_up():
	if linterna_animacion_count != 0:
		cancel_foxy_animation()
	if linterna_activada:
		set_linterna(false)
	did_click_on = false


func _on_timer_linterna_tic():
	#if linterna_animacion_count == 0:
	Global.linterna_bateria -= 1

func _on_oficina_detras_linterna_recarga_switch_rebote() -> void:
	linterna_recargando = !linterna_recargando
	if linterna_activada:
		set_linterna(false)
	Linterna_Recargando_Switch.emit()

func _on_timer_recargar_linterna_tic_recarga() -> void:
	if Global.energia["Linterna"]:
		Global.linterna_bateria += 1

##foxy animation

func foxy_animacion():
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Flashlight animation")
	linterna_animacion()

func cancel_foxy_animation():
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Flashlight animation canceled")
	linterna_animacion_timer.stop()
	linterna_animacion_count = 0
	set_linterna(false)

const ANIMATION := true
const ITERATIONS_ON_FOXY_ANIMATION := 9
func linterna_animacion():
	linterna_animacion_count = ITERATIONS_ON_FOXY_ANIMATION
	set_linterna(false, ANIMATION)
	linterna_animacion_timer.start(0.3 * 5.0 / tick_rate)

func _on_linterna_animacion_timeout() -> void:
	linterna_animacion_count -= 1
	set_linterna(!linterna_activada, ANIMATION)

	if linterna_animacion_count > 0:
		if linterna_animacion_count > 3:
			linterna_animacion_timer.start((0.1 * (linterna_animacion_count - 2) / 3.0) * 5.0 / tick_rate)
		elif linterna_animacion_count == 1:
			Foxy.move_back_to()
			linterna_animacion_timer.start(0.3 * 5.0 / tick_rate)
		else:
			linterna_animacion_timer.start((0.1 * 3.0 / 4.0) * 5.0 / tick_rate)
