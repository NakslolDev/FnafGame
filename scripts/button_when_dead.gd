extends Button

@export var id: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	text = root_node.get_text(id + Global.misc["When_dead_go_to"])

func _on_pressed() -> void:
	if Global.misc["When_dead_go_to"] == "night":
		Global.misc["When_dead_go_to"] = "menu"
	elif Global.misc["When_dead_go_to"] == "menu":
		Global.misc["When_dead_go_to"] = "shift"
	else:
		Global.misc["When_dead_go_to"] = "night"
	_ready()
