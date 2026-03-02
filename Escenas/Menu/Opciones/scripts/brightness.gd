extends VBoxContainer

@export var label: Label
@export var h_slider: HSlider

@export var id: String
@export var root_node: Node

func _ready():
	label.text = root_node.get_text(id)
	h_slider.value = Global.screen["brightness"]


func _on_h_slider_value_changed(value: float) -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = value


func _on_h_slider_drag_ended(_value_changed: bool) -> void:
	Global.screen["brightness"] = h_slider.value
