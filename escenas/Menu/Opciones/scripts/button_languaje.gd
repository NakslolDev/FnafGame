extends Button

@export var id: String
@onready var root_node = get_tree().current_scene

func _ready():
	$".".text = root_node.get_text(id)
