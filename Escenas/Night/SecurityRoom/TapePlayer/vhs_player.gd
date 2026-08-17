extends Node2D

@export var main_game: Node2D

var playing: bool
var scarlet_forest := false
@export var vhs_colider: Area2D

@export var normal: Node2D
@export var play: Node2D
@export var message: Node2D
@export var darkest: BrightSprite

@export var new_message: Timer
const TIMER_LONG := 4.0
const TIMER_SHORT := 0.5

@export_category("Audios")
@export var audio_nights_en: Array[AudioStream]
@export var audio_nights_es: Array[AudioStream]

func _ready():
	vhs_colider.add_to_group("interactable")
	call_deferred("change_audio", Global.noche)

func change_audio(index: int):
	
	var new_audio: AudioStream
	
	if Global.audio_language == "En": new_audio = audio_nights_en[index]
	elif Global.audio_language == "Es": new_audio = audio_nights_es[index]
	
	DirectionalAudioBus.vhs_change_audio_stream.emit(new_audio)
	act_status(status.OFF)
	new_message.start(TIMER_LONG)

enum status {OFF, PAUSED, PLAYING}
func act_status(stat: status):

	if main_game != null and (main_game.camaras_activadas or main_game.tick_stop):
		return

	if not new_message.is_stopped():
		new_message.stop()
		message.visible = false

	if stat == status.PLAYING:
		play.visible = true
		normal.visible = false
		playing = true


	else:
		play.visible = false
		normal.visible = true
		playing = false

	DirectionalAudioBus.vhs_act_audio.emit(stat)


func _on_stop_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		act_status(status.OFF)

func _on_play_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if not playing:
			act_status(status.PLAYING)
		else:
			act_status(status.PAUSED)


func _on_main_game_on_tick_stop() -> void:
		DirectionalAudioBus.vhs_act_audio.emit(status.OFF)


func _on_new_message_timeout() -> void:
	#darkest.modulate.a = 1.0 - float(Global.energia["Luces"])
	message.visible = !message.visible
	#normal.visible = !message.visible
	new_message.start(TIMER_SHORT)
