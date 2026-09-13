extends Node2D

@export var upper: Node2D
@export var down: Node2D
@export var player: CharacterBody2D

func _process(_delta: float) -> void:
	upper.visible = player.global_position.y < global_position.y
	down.visible = !upper.visible
