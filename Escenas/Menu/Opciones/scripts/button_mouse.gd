extends Button

@export var id: String
@export var root_node: Node
var _text

func _ready():
	_text = root_node.get_text(id)
	actualizar_puntero(false)

func _on_pressed() -> void:
	actualizar_puntero(true)

func actualizar_puntero(cambiar: bool):
	
	if cambiar:
		var punt: int = str_to_var(Global.mouse_custom_punt)
		punt += 1
		if punt == 6:
			punt = 1
		Global.mouse_custom_punt = str(punt)
	
	text = _text + " " + Global.mouse_custom_punt
