extends Button

@export var id: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	$".".text = root_node.get_text(id)
	if Global.misc["Auto_cam_lights"]:
		$Label.visible = false
	else:
		$Label.visible = true

func _on_pressed() -> void:
	Global.misc["Auto_cam_lights"] = ! Global.misc["Auto_cam_lights"]
	_ready()
