extends Button

@export var id: String
@export var root_node: Node

func _ready():
	text = root_node.get_text(id)
