extends Button

@export var id_on: String
@export var id_off: String
@export var root_node: Node
var active

func _ready():
	if active:
		text = root_node.get_text(id_on)
	else:
		text = root_node.get_text(id_off)

func _on_pressed() -> void:
	pass
