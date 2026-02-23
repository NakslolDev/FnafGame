extends Node2D

@export var oficina_lights_out_alpha: Sprite2D
@export var irritating_light: AudioStreamPlayer


@export var light_out_custom := false
@export_range(0.0, 1.0, 0.01)
var oscuridad := 0.2

func _ready():
	visible = true
	oficina_lights_out_alpha.modulate.a = oscuridad
	Global.energia_actualizada.connect(energia_act)
	irritating_light.play()

func energia_act():
	if Global.energia["Luces"] or light_out_custom:
		oficina_lights_out_alpha.modulate.a = oscuridad
		if randi_range(0, 1000) == 0 and irritating_light.stream_paused: #por que cojones tengo esto aqui?????? xd?
			irritating_light.volume_db = 20.0
		else:
			irritating_light.volume_db = 3.0
		irritating_light.stream_paused = false
	else:
		oficina_lights_out_alpha.modulate.a = 0.5
		irritating_light.stream_paused = true
