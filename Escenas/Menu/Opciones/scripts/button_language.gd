extends Button

@export var id: String
@export var root_node: Node

@export_group("Languajes")
@export var English := true
@export var Spanish := true
@export var Deutsch := true

func _ready():
	text = root_node.get_text(id)

func _on_pressed() -> void:
	actualizar_lenguaje()

func actualizar_lenguaje():
	
	var idiomas = []
	if English:
		idiomas.append("En")
	if Spanish:
		idiomas.append("Es")
	if Deutsch:
		idiomas.append("De")
	
	var index = idiomas.find(Global.language)
	if index == -1:
		return
	index = (index + 1) % idiomas.size()
	Global.language = idiomas[index]
	
	root_node.change_language()
