extends Label

@export var id: String
@onready var root_node = get_tree().current_scene
var _text

func _ready():
	_text = root_node.get_text(id)
	$"../HSlider".value = Global.minigame_text_speed_mult
	_on_h_slider_value_changed(Global.minigame_text_speed_mult)


func _on_h_slider_value_changed(value: float) -> void:
	text = " " + _text + ": " + str(value)
	Global.minigame_text_speed_mult = value
