extends CheckBox

func _ready():
	visible = false

func _on_spin_box_night_value_changed(value: int) -> void:
	if value == 6:
		visible = true
	else:
		visible = false
		button_pressed = false
