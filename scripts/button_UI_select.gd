extends Button

@export var id_energy: String
@export var id_flashlight: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	$".".text = root_node.get_text(id_energy)

var energia := true

func _on_pressed() -> void:
	energia = !energia
	if energia:
		text = root_node.get_text(id_energy)
		$"../Button_Customice_UI".act_text(true)
	else:
		text = root_node.get_text(id_flashlight)
		$"../Button_Customice_UI".act_text(false)
