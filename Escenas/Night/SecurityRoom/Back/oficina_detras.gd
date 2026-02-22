extends Node2D

signal Girar_Detras(izquierda: bool)
signal Linterna_Activada_Rebote()
signal Linterna_Recarga_Switch_Rebote()
signal Detras_Estado(Detras: bool)

var stop_everything := false

func _on_detector_girar_izquierda_girar(izquierda: bool) -> void:

	position.y = 0
	if izquierda:
		position.x = -3120
	else:
		position.x = 3120


func _on_detector_girar_girar(izquierda: bool) -> void:
	emit_signal("Girar_Detras", izquierda)


func _on_linterna_linterna_activada_switch() -> void:
	emit_signal("Linterna_Activada_Rebote")


func _on_recargar_linterna_linterna_recarga_switch() -> void:
	emit_signal("Linterna_Recarga_Switch_Rebote")


func _on_oficina_girando_estado(girando: int) -> void:
	if girando == 3:
		emit_signal("Detras_Estado", true)
	else:
		emit_signal("Detras_Estado", false)


func _on_oficina_girar_input_permitido(izquierda: bool, detras: bool) -> void:
	if detras:
		if izquierda:
			$Detector_Girar_I.emit_signal("Girar", true)
		else:
			$Detector_Girar_D.emit_signal("Girar", false)
