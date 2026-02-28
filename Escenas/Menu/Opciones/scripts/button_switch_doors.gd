extends Button

@export var id_on: String
@export var id_off: String
@export var root_node: Node

func _ready():
	if Global.misc["Switch_Doors_Back"]:
		text = root_node.get_text(id_on)
	else:
		text = root_node.get_text(id_off)

func _on_pressed() -> void:
	Global.misc["Switch_Doors_Back"] = ! Global.misc["Switch_Doors_Back"]
	_ready()
