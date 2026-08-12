extends Node2D

signal Linterna_Recarga_Switch()

@export var linterna_recargando: Node2D
@export var agarrar: AudioStreamPlayer
@export var encajar: AudioStreamPlayer
@export var office_behind: Node2D

var _recargando: bool
var recargando := false:
	get: return _recargando
	set(value):
		_recargando = value
		linterna_consum()

func energia_act():
	linterna_consum()

func linterna_consum():
	if _recargando and Global.energia["Linterna"]:
		Global.set_energia_consumption("Linterna_Rec", 1)
	else:
		Global.set_energia_consumption("Linterna_Rec", 0)

var detras := false

func _ready():
	Global.set_energia_consumption("Linterna_Rec", 0)
	Global.energia_actualizada.connect(energia_act)
	linterna_recargando.visible = false

func _on_click():
	if office_behind.stop_everything == true:
		return
	Linterna_Recarga_Switch.emit()
	recargando = !recargando
	linterna_recargando.visible = recargando
	DirectionalAudioBus.encajar_linterna.emit(recargando)

func _input(event):
	if detras:
		if event.is_action_pressed("Space"):
			_on_click()


func _on_oficina_detras_detras_estado(Detras: bool) -> void:
	detras = Detras
