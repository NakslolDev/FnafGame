extends Sprite2D



var red: bool = false
func _on_timer_timeout() -> void:
	if red:
		modulate.b = 1.0
		modulate.g = 1.0
	else:
		modulate.b = 0.25
		modulate.g = 0.25
	red = !red
