extends Node2D

@export var player: CharacterBody2D
@export var Walls: Array[Node2D]

var last_player_ypos: float

const FADE_TIME := 0.5

func _ready():
	for wall: Node2D in Walls: # Esto lo hago para mantener las paredes invisibles, ya que tapan mucho
		wall.visible = true
		if player.position.y >= wall.position.y:
			wall.modulate.a = 1.0
		else:
			wall.modulate.a -= 0.0


func _process(delta: float) -> void: # Podria optimizarse, pero de momento lo vamos a dejar asi, pues tampoco hay problema
	for wall: Node2D in Walls:
		if player.position.y >= wall.position.y:
			if wall.modulate.a <= 1.0:
				wall.modulate.a += delta / FADE_TIME
		else:
			if wall.modulate.a >= 0.0:
				wall.modulate.a -= delta / FADE_TIME
