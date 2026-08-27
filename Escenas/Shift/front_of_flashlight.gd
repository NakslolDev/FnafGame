extends Sprite2D

@export var player: CharacterBody2D
@export var left: Node2D
@export var right: Node2D

const QUICK := 1.5

func _process(delta: float) -> void:
	var dentro := player.global_position.x < right.global_position.x and player.global_position.x > left.global_position.x and player.global_position.y < left.global_position.y
	modulate.a = move_toward(modulate.a, 1.0 if dentro else 0.0, QUICK * delta)
