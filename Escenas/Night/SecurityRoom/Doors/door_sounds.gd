extends CanvasLayer

@export var puerta_izquierda: AudioStreamPlayer2D
@export var puerta_derecha: AudioStreamPlayer2D

@export var oficina: Node2D

@export var audio_distancia := 1000
var local_girando: int

func _process(_delta):
	if local_girando == 0:
		puerta_derecha.position.x = audio_distancia + oficina.position.x * 2
		puerta_izquierda.position.x = -audio_distancia + oficina.position.x * 2
	else:
		puerta_derecha.position.x = audio_distancia
		puerta_izquierda.position.x = -audio_distancia

func _on_puerta_izquierda_sound() -> void:
	if local_girando == 0 or local_girando == 1 or local_girando == 2:
		puerta_izquierda.play()
	elif local_girando == 3 or local_girando == -1 or local_girando == -2:
		puerta_derecha.play()

func _on_puerta_derecha_sound() -> void:
	if local_girando == 0 or local_girando == 1 or local_girando == 2:
		puerta_derecha.play()
	elif local_girando == 3 or local_girando == -1 or local_girando == -2:
		puerta_izquierda.play()

func _on_oficina_girando_estado(girando: int) -> void:
	local_girando = girando
