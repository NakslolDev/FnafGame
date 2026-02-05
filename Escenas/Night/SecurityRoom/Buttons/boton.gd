extends Node2D

signal Puerta_Cambio(puerta_activada: bool)

signal Mouse_Entered_Switch()

@export var boton_izquierda := true
var puerta_activada := false
var mouse_entered := false
var local_girando: int

func _ready():
	$ButtonOff.volume_linear = 0.0
	$ButtonOn.volume_linear = 0.0
	if boton_izquierda:
		$ButtonOn.position.x = -500
		$ButtonOff.position.x = -500
	else:
		$ButtonOn.position.x = 500
		$ButtonOff.position.x = 500

	actualizar_sprites()
	Global.connect("energia_actualizada", Callable(self, "energia_act"))

func energia_act():
	actualizar_sprites()
	if puerta_activada and Global.energia["Puertas"] == false:
		puerta_activada = false
		emit_signal("Puerta_Cambio", puerta_activada)

func _on_click():
	if $"../..".camaras_activadas or $"../..".tick_stop:
		return
	$ButtonOff.volume_linear = 1.0
	$ButtonOn.volume_linear = 1.0
	if local_girando == 0 or local_girando == 3:
		if Global.energia["General"] and Global.energia["Puertas"]:
			puerta_activada = !puerta_activada
			emit_signal("Puerta_Cambio", puerta_activada)
			actualizar_sprites()
	
func _input(event):
	if boton_izquierda:
		if local_girando == 3 and Global.misc["Switch_Doors_Back"]:
			if event.is_action_pressed("Puerta_Derecha"):
				_on_click()
		else:
			if event.is_action_pressed("Puerta_Izquierda"):
				_on_click()
	
	else:
		if local_girando == 3 and Global.misc["Switch_Doors_Back"]:
			if event.is_action_pressed("Puerta_Izquierda"):
				_on_click()
		else:
			if event.is_action_pressed("Puerta_Derecha"):
				_on_click()

func actualizar_sprites():
	if Global.energia["General"] and Global.energia["Puertas"]:
		$OficinaBotonNoEnergia.modulate.a = 0.0
		if puerta_activada:
			$OficinaBotonRojo.modulate.a = 0.0
			$OficinaBotonVerde.modulate.a = 1.0
			$ButtonOn.play()
		else:
			$OficinaBotonRojo.modulate.a = 1.0
			$OficinaBotonVerde.modulate.a = 0.0
			$ButtonOff.play()
	else:
		$OficinaBotonNoEnergia.modulate.a = 1.0


func _on_area_boton_mouse_entered() -> void:
	emit_signal("Mouse_Entered_Switch")

func _on_area_boton_mouse_exited() -> void:
	emit_signal("Mouse_Entered_Switch")

func _on_oficina_girando_estado(girando: int) -> void:
	local_girando = girando
