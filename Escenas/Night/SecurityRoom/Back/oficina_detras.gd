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
	Girar_Detras.emit(izquierda)


func _on_linterna_linterna_activada_switch() -> void:
	Linterna_Activada_Rebote.emit()


func _on_recargar_linterna_linterna_recarga_switch() -> void:
	Linterna_Recarga_Switch_Rebote.emit()


func _on_oficina_girando_estado(girando: int) -> void:
	Detras_Estado.emit(girando == 3)

@export var detector_girar_i: Node2D
@export var detector_girar_d: Node2D

func _on_oficina_girar_input_permitido(izquierda: bool, detras: bool) -> void:
	if detras:
		if izquierda:
			detector_girar_i.Girar.emit(true)
		else:
			detector_girar_d.Girar.emit(false)


func _on_main_game_on_tick_stop() -> void:
	stop_everything = true
