extends Button

@export var audio := false
@export var id: String
@export var root_node: Node

@export_group("Languajes")
@export var English := true
@export var Spanish := true
@export var Deutsch := false

func _ready():
	if audio:
		text = root_node.get_text(id + "_" + Global.audio_language)
	else:
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
	
	var index
	if audio:
		index = idiomas.find(Global.audio_language)
	else:
		index = idiomas.find(Global.language)
	
	if index == -1:
		return
	index = (index + 1) % idiomas.size()
	
	if audio:
		Global.audio_language = idiomas[index]
	else:
		Global.language = idiomas[index]
	
	if audio:
		_ready()
	else:
		root_node.change_language()
