extends Button

@export var id_energy: String
@export var id_flashlight: String
@export var root_node: Node
@export var button_customice_ui: Button


func _ready():
	text = root_node.get_text(id_energy)

var energia := true

func _on_pressed() -> void:
	energia = !energia
	if energia:
		text = root_node.get_text(id_energy)
		button_customice_ui.act_text(true)
	else:
		text = root_node.get_text(id_flashlight)
		button_customice_ui.act_text(false)
