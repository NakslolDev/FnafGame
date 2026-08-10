extends Node2D

@export var oficina_lights_out_alpha: Sprite2D
@export var irritating_light: AudioStreamPlayer


@export var light_out_custom := false

@export var bright_sprites_visibility_control: Node2D

const DEFAULT_ALPHA := 0.2
const DARK_ALPHA := 0.5

func _ready():
	visible = true
	bright_sprites_visibility_control.visible = false
	oficina_lights_out_alpha.modulate.a = DEFAULT_ALPHA
	Global.energia_actualizada.connect(energia_act)
	irritating_light.play()

func energia_act():
	if Global.energia["Luces"] or light_out_custom:
		oficina_lights_out_alpha.modulate.a = DEFAULT_ALPHA
		if randi_range(0, 1000) == 0 and irritating_light.stream_paused: #por que cojones tengo esto aqui?????? xd?
			irritating_light.volume_db = 20.0
		else:
			irritating_light.volume_db = 3.0
		irritating_light.stream_paused = false
		bright_sprites_visibility_control.visible = false
	else:
		oficina_lights_out_alpha.modulate.a = DARK_ALPHA
		irritating_light.stream_paused = true
		bright_sprites_visibility_control.visible = true


func _on_main_game_on_tick_stop() -> void:
	irritating_light.stop()
