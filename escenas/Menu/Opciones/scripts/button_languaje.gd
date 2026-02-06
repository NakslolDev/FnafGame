extends Button

@export var id: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	$".".text = root_node.get_text(id)
