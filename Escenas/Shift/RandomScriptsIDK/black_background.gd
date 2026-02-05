extends Sprite2D

@export var cam: Camera2D

func _physics_process(_delta: float) -> void:
	position = cam.position
