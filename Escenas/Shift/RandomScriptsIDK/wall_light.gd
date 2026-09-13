extends PointLight2D

func _process(delta: float) -> void:
	visible = modulate.a > 0.001
