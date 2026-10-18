extends Node2D

const SPEED := 2
const FLOOR := 8.0

func _on_timer_move_timeout() -> void:
	position.y += SPEED
	if position.y >= FLOOR:
		delete()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	delete()

func delete():
	queue_free()
