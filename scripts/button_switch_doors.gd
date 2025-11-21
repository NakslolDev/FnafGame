extends Button

@export var id: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	$".".text = root_node.get_text(id)
	if Global.misc["Switch_Doors_Back"]:
		$Label.visible = false
	else:
		$Label.visible = true

func _on_pressed() -> void:
	Global.misc["Switch_Doors_Back"] = ! Global.misc["Switch_Doors_Back"]
	_ready()
