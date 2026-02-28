extends Node

@export var ventilation_loop: AudioStreamPlayer

var vent := true
@export var speed := 0.5
@export var pitch := 1.0
@export var volume := 1.0

func _ready():
	Global.energia_actualizada.connect(act_ventilacion)
	ventilation_loop.volume_linear = volume
	ventilation_loop.play()

func _process(delta):
	if vent:
		if ventilation_loop.volume_linear < volume:
			ventilation_loop.volume_linear += speed * delta
		if ventilation_loop.pitch_scale < pitch:
			ventilation_loop.pitch_scale += speed * 2 * delta
	else:
		if  ventilation_loop.volume_linear > speed * delta:
			ventilation_loop.volume_linear -= speed * delta
		if ventilation_loop.pitch_scale > speed * 2 * delta:
			ventilation_loop.pitch_scale -= speed * 2 * delta

func act_ventilacion():
	if Global.energia["Ventilacion"] == true:
		vent = true
	else:
		vent = false


func _on_main_game_on_tick_stop() -> void:
	ventilation_loop.stop()
