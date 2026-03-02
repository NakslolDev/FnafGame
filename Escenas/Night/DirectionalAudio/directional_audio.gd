extends Node2D

var sounds: Array[spacial_audio] = [] # rellenamos en ready

func _ready() -> void:
	_append_sounds_recursively()

func _append_sounds_recursively(father: Node = self):
	for node in father.get_children():
		if node is spacial_audio:
			sounds.append(node)
		else:
			_append_sounds_recursively(node)

@export var oficina: Node2D

var _local_security_room_position: float

func _physics_process(_delta: float) -> void:
	if oficina == null: # asi no peta
		return
	if _local_security_room_position == oficina.position.x:
		return
	
	_local_security_room_position = oficina.position.x
	
	for audio in sounds:
		audio.change_pos(_local_security_room_position)


@export var puerta_izquierda: spacial_audio
@export var puerta_derecha: spacial_audio

func _on_puerta_izquierda_sound() -> void:
	puerta_izquierda.play()

func _on_puerta_derecha_sound() -> void:
	puerta_derecha.play()


@export var left_button_off: spacial_audio
@export var left_button_on: spacial_audio
@export var right_button_off: spacial_audio
@export var right_button_on: spacial_audio

func _on_boton_izquierda_button_play(on: bool) -> void:
	if on:
		left_button_on.play()
	else:
		left_button_off.play()

func _on_boton_derecha_button_play(on: bool) -> void:
	if on:
		right_button_on.play()
	else:
		right_button_off.play()


@export var vhs_sound: spacial_audio
func _on_vhs_player_act_audio(stat: int) -> void:
	if stat == 0:
		vhs_sound.stop()
		vhs_sound.stream_paused = false

	if stat == 1:
		vhs_sound.stream_paused = true

	if stat == 2:
		if vhs_sound.stream_paused:
			vhs_sound.stream_paused = false
		else:
			vhs_sound.play()

func _on_vhs_player_change_audio_stream(new: AudioStream) -> void:
	vhs_sound.stream = new
