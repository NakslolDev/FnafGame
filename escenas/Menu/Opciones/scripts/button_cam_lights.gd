extends Button

@export var id_on: String
@export var id_off: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	if Global.misc["Auto_cam_lights"]:
		$".".text = root_node.get_text(id_on)
	else:
		$".".text = root_node.get_text(id_off)

func _on_pressed() -> void:
	Global.misc["Auto_cam_lights"] = ! Global.misc["Auto_cam_lights"]
	_ready()
