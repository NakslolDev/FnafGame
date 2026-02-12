extends Sprite2D

@export var cam: Camera2D

func _process(_delta: float) -> void:
	position = cam.position
