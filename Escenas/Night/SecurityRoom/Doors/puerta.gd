extends Node2D

@export var puerta_izquierda := true
@export var posicion_abierta := Vector2(0, -1200)
@export var posicion_cerrada := Vector2(0, 0)
@export var velocidad := 4000.0

signal Sound()

var estado: Vector2

func _ready():
	Global.set_energia_consumption("Puerta_I", 0)
	Global.set_energia_consumption("Puerta_D", 0)
	estado = posicion_abierta

func _process(delta):
	position = position.move_toward(estado, velocidad * delta)

func _on_boton_izquierda_puerta_cambio(puerta_activada: bool) -> void:
	play_puerta()
	if puerta_activada:
		estado = posicion_cerrada  # Baja
		Global.set_energia_consumption("Puerta_I", 1)
		if Global.energia["Puertas"]:
			Bonnie.door_closed = true
			Freddy.door_I_closed = true
			Foxy.door_I_closed = true
			print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "left door closed")
	else:
		estado = posicion_abierta  # Sube
		Global.set_energia_consumption("Puerta_I", 0)
		Bonnie.door_closed = false
		Freddy.door_I_closed = false
		Foxy.door_I_closed = false
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "left door opend")

func _on_boton_derecha_puerta_cambio(puerta_activada: bool) -> void:
	play_puerta()
	if puerta_activada:
		estado = posicion_cerrada  # Baja
		Global.set_energia_consumption("Puerta_D", 1)
		if Global.energia["Puertas"]:
			Chica.door_closed = true
			Freddy.door_D_closed = true
			Foxy.door_D_closed = true
			print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "right door closed")
	else:
		estado = posicion_abierta  # Sube
		Global.set_energia_consumption("Puerta_D", 0)
		Chica.door_closed = false
		Freddy.door_D_closed = false
		Foxy.door_D_closed = false
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "right door opend")

func play_puerta():
	$Timer.start()

func _on_timer_timeout() -> void:
	Sound.emit()
