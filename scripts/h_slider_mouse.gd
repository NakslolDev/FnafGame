extends HSlider

var last_mouse_op
var new_mouse_op
signal Warning_Op

func _ready():
	value = Global.mouse_custom_op
	last_mouse_op = value

func _on_value_changed(new_value: float) -> void:
	Global.mouse_custom_op = new_value

func _on_drag_ended(_xd_value) -> void:
	if value < 0.1:
		emit_signal("Warning_Op")
		new_mouse_op = value
		Global.mouse_custom_op = 1.0
	else:
		last_mouse_op = value

func _on_button_ik_pressed() -> void:
	Global.mouse_custom_op = new_mouse_op

func _on_button_cancel_pressed() -> void:
	value = last_mouse_op
	Global.mouse_custom_op = value
