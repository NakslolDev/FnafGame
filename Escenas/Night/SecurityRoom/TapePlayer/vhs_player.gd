extends Node2D

@export var main_game: Node2D

var playing: bool
var scarlet_forest := false
@export var vhs_colider: Area2D

@export var timer: Timer
@export var play_on: Sprite2D
@export var pause_on: Sprite2D
@export var stop_on: Sprite2D

@export_category("Audios")
@export var audio_nights: Array[AudioStream]

signal act_audio(stat: status)
signal change_audio_stream(new: AudioStream)

func _ready():
	vhs_colider.add_to_group("interactable")
	change_audio()

func change_audio(index: int = -1):
	
	var new_audio: AudioStream
	
	if index == -1:
		new_audio = audio_nights[Global.noche]
	
	else:
		push_warning("There is still not any audio for this")
	
	change_audio_stream.emit(new_audio)
	act_status(status.OFF)

enum status {OFF, PAUSED, PLAYING}
func act_status(stat: status):
	
	if main_game != null and (main_game.camaras_activadas or main_game.tick_stop):
		return
	
	if stat == status.OFF:
		play_on.visible = false
		pause_on.visible = false
		stop_on.visible = true
		playing = false
		timer.stop()
	
	elif stat == status.PAUSED:
		play_on.visible = false
		pause_on.visible = true
		stop_on.visible = false
		playing = false
		timer.stop()
	
	elif stat == status.PLAYING:
		play_on.visible = true
		pause_on.visible = false
		stop_on.visible = false
		playing = true
		timer.start()
	
	act_audio.emit(stat)


func _on_stop_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		act_status(status.OFF)

func _on_pause_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if playing:
			act_status(status.PAUSED)
		else:
			act_status(status.PLAYING)

func _on_play_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if not playing:
			act_status(status.PLAYING)


func _on_main_game_on_tick_stop() -> void:
		act_audio.emit(status.OFF)
