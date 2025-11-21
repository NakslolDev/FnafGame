extends Node2D

signal Camera_Movement(direction: int) # Envia una señal con la direccion del movimiento
var recordar_posicion: int

func stop_movement():
	emit_signal("Camera_Movement", 0)

func remember():
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", recordar_posicion)

func _on_centro_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", 0) # 0 es parado
	recordar_posicion = 0

func _on_izquierda_suave_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", -1) # - es la direccion
	recordar_posicion = -1

func _on_izquierda_fuerte_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", -2) # 2 es la intensidad (2 > 1)
	recordar_posicion = -2

func _on_izquierda_fortisimo_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", -4)
	recordar_posicion = -4

func _on_derecha_suave_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", 1)
	recordar_posicion = 1

func _on_derecha_fuerte_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", 2)
	recordar_posicion = 2

func _on_derecha_fortisimo_mouse_entered() -> void:
	if $"..".camaras_activadas == false and $"..".tick_stop == false:
		emit_signal("Camera_Movement", 4)
	recordar_posicion = 4
