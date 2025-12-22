extends Node

@export var player: CharacterBody2D
var last_player_ypos: float

const fade_speed := 2.0

func _process(delta: float) -> void: # Podria optimizarse, pero de momento lo vamos a dejar asi, pues tampoco hay problema
	for wall: Node2D in get_children():
		if player.position.y >= wall.position.y:
			if wall.modulate.a <= 1.0:
				wall.modulate.a += fade_speed * delta
		else:
			if wall.modulate.a >= 0.0:
				wall.modulate.a -= fade_speed * delta
