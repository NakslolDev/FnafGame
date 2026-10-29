extends Button

@export var id_on: String
@export var id_off: String
@export var root_node: Node

func _ready():
	if Global.experimental["fuses"]:
		text = root_node.get_text(id_on)
	else:
		text = root_node.get_text(id_off)

func _on_pressed() -> void:
	Global.experimental["fuses"] = !Global.experimental["fuses"]
	_ready()
