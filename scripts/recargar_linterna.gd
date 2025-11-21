extends Node2D

signal Linterna_Recarga_Switch()
signal Linterna_Recarga_Mouse_Switch()

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
	Global.connect("energia_actualizada", Callable(self, "energia_act"))
	$LinternaRecargando.modulate.a = 0.0

func _on_click():
	if $"..".stop_everything == true:
		return
	emit_signal("Linterna_Recarga_Switch")
	recargando = !recargando
	if recargando:
		$LinternaRecargando.modulate.a = 1.0
		$Encajar.play()
	else:
		$LinternaRecargando.modulate.a = 0.0
		$Agarrar.play()

func _input(event):
	if detras:
		if event.is_action_pressed("Space"):
			_on_click()

func _on_area_2d_mouse_entered() -> void:
	emit_signal("Linterna_Recarga_Mouse_Switch")

func _on_area_2d_mouse_exited() -> void:
	emit_signal("Linterna_Recarga_Mouse_Switch")

func _on_oficina_detras_detras_estado(Detras: bool) -> void:
	detras = Detras
