extends Node

func _ready() -> void:
	exit_blackout.visible = true
	exit_blackout.modulate.a = 0.0

@export var character_chica: CharacterBody2D
@export var position: Node2D
@export var exit_blackout: Sprite2D
@export var map: Node
func _on_no_exit_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	character_chica.global_position.y = position.global_position.y #no hago locate to para no triggerear la señal
	if exit_blackout.modulate.a < 1.0: exit_blackout.modulate.a += 0.2
	if exit_blackout.modulate.a >= 1.0: map.free_exit()

func _on_character_chica_teleported() -> void:
	if exit_blackout.modulate.a > 0.0:
		exit_blackout.modulate.a = 0.0
		character_chica.locate_x(position)
		map.unfree_exit()
