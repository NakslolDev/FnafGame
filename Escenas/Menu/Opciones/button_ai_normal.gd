extends Button

@export var id_off: String
@export var id_normal: String
@export var id_hard: String
@export var root_node: Node

func _ready():
	match Global.experimental["ai_normalizer"]:
		0:
			text = root_node.get_text(id_off)
		1:
			text = root_node.get_text(id_normal)
		2:
			text = root_node.get_text(id_hard)
		_:
			Global.experimental["ai_normalizer"] = 0
			_ready()

func _on_pressed() -> void:
	Global.experimental["ai_normalizer"] += 1
	_ready()
