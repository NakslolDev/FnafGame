extends Area2D

func _ready():
	add_to_group("interactable")

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent()._on_click()
