extends Node2D

@export var player: CharacterBody2D
@export var Walls: Array[CanvasGroup]

var last_player_ypos: float

const FADE_TIME := 0.5

func _ready():
	for wall in Walls: # Esto lo hago para mantener las paredes invisibles, ya que tapan mucho
		wall.visible = true
		if player.position.y >= wall.position.y:
			wall.self_modulate.a = 1.0
		else:
			wall.self_modulate.a = 0.0


func _process(delta: float) -> void: # Podria optimizarse, pero de momento lo vamos a dejar asi, pues tampoco hay problema
	for wall in Walls:
		if player.position.y >= wall.position.y:
			if wall.self_modulate.a <= 1.0:
				wall.self_modulate.a += delta / FADE_TIME
		else:
			if wall.self_modulate.a >= 0.0:
				wall.self_modulate.a -= delta / FADE_TIME
