extends Button

@export var id_on: String
@export var id_off: String
@onready var root_node = get_node("/root/Opciones")
var active

func _ready():
	if active:
		$".".text = root_node.get_text(id_on)
	else:
		$".".text = root_node.get_text(id_off)

func _on_pressed() -> void:
	pass
