extends Node2D

var sounds: Array[spacial_audio] = [] # rellenamos en ready

func _ready() -> void:
	_append_sounds_recursively()
	
	DirectionalAudioBus.puerta.connect(_puerta_sound)
	DirectionalAudioBus.button.connect(_button_sound)
	DirectionalAudioBus.button_failed.connect(_button_failed)
	DirectionalAudioBus.vhs_act_audio.connect(_vhs_player_act_audio)
	DirectionalAudioBus.vhs_change_audio_stream.connect(_vhs_player_change_audio_stream)
	DirectionalAudioBus.encajar_linterna.connect(_encajar_linterna)
	DirectionalAudioBus.switch.connect(_switch_click)
	Global.Energy_Breakdown.connect(electric_breakdown_play)
	Global.Fuse_Breakdown.connect(fuse_breakdown_play)

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

func _puerta_sound(izquierda: bool) -> void:
	if izquierda: puerta_izquierda.play()
	else: puerta_derecha.play()


@export var left_button_off: spacial_audio
@export var left_button_on: spacial_audio
@export var right_button_off: spacial_audio
@export var right_button_on: spacial_audio
func _button_sound(izquierda: bool, on: bool) -> void:
	if izquierda:
		if on: left_button_on.play()
		else: left_button_off.play()
	else:
		if on: right_button_on.play()
		else: right_button_off.play()

@export var left_button_fail: spacial_audio
@export var right_button_fail: spacial_audio
func _button_failed(izquierda: bool) -> void:
	if izquierda: left_button_fail.play()
	else: right_button_fail.play()


@export var vhs_sound: spacial_audio
func _vhs_player_act_audio(stat: int) -> void:
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

func _vhs_player_change_audio_stream(new: AudioStream) -> void:
	vhs_sound.stream = new

@export var agarrar: spacial_audio
@export var encajar: spacial_audio

func _encajar_linterna(recargando: bool):
	if recargando: encajar.play()
	else: agarrar.play()

@export var general: spacial_audio
@export var ventilation: spacial_audio
@export var puertas: spacial_audio
@export var flashlight: spacial_audio
@export var cameras: spacial_audio
@export var heater: spacial_audio
@export var luces: spacial_audio

func _switch_click(controlador: String):
	match (controlador):
		"General":
			general.play()
		"Ventilacion":
			ventilation.play()
		"Puertas":
			puertas.play()
		"Linterna":
			flashlight.play()
		"Camaras":
			cameras.play()
		"Heater":
			heater.play()
		"Luces":
			luces.play()

@export var electric_breakdown: spacial_audio
func electric_breakdown_play():
	electric_breakdown.play()

@export var fuse_breakdown: spacial_audio
func fuse_breakdown_play(_switch):
	fuse_breakdown.play()
