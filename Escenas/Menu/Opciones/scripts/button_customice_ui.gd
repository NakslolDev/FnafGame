extends Button

@export var id_energy: String
@export var id_flashlight: String
@export var root_node: Node

func _ready():
	act_text(true)

func act_text(energy: bool):
	if energy:
		text = root_node.get_text(id_energy)
	else:
		text = root_node.get_text(id_flashlight)
