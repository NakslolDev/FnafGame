extends Button

@export var id: String
@export var root_node: Node

func _ready():
	text = root_node.get_text(id + Global.misc["When_win_go_to"])

func _on_pressed() -> void:
	if Global.misc["When_win_go_to"] == "menu":
		Global.misc["When_win_go_to"] = "shift"
	else:
		Global.misc["When_win_go_to"] = "menu"
	_ready()
