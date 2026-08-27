extends Node2D

@export var upper: LightOccluder2D
@export var down: LightOccluder2D
@export var player: CharacterBody2D

func _process(_delta: float) -> void:
	upper.visible = player.global_position.y < global_position.y
	down.visible = !upper.visible
