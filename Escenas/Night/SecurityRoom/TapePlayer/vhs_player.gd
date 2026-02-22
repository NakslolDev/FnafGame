extends Node2D

var audio: Node
var scarlet_forest := false
@export var vhs_colider: Area2D


func _ready():
	vhs_colider.add_to_group("interactable")
	act_audio()
	act_status(0)

func act_audio():
	if scarlet_forest:
		audio = $Audios/ScarletForest
	else:
		if Global.noche == 1:
			audio = $Audios/Noche1
		elif Global.noche == 2:
			audio = $Audios/Noche2
		elif Global.noche == 3:
			audio = $Audios/Noche3
		elif Global.noche == 4:
			audio = $Audios/Noche4
		elif Global.noche == 5:
			audio = $Audios/Noche5
		elif Global.noche == 6:
			audio = $Audios/Noche6
		else:
			audio = $Audios/ScarletForest
	
	if audio and not audio.is_connected("finished", Callable(self, "_on_audio_finished")):
		audio.connect("finished", Callable(self, "_on_audio_finished")) # conecta la señal

func act_status(status: int):
	
	if status == 0:
		$Play/PlayOn.visible = false
		$Pause/PauseOn.visible = false
		$Stop/StopOn.visible = true
		audio.stream_paused = false
		audio.stop()
		$Gyro/Timer.stop()
	
	elif status == 1:
		$Play/PlayOn.visible = false
		$Pause/PauseOn.visible = true
		$Stop/StopOn.visible = false
		audio.stream_paused = true
		$Gyro/Timer.stop()
	
	elif status == 2:
		$Play/PlayOn.visible = true
		$Pause/PauseOn.visible = false
		$Stop/StopOn.visible = false
		if audio.stream_paused == true:
			audio.stream_paused = false
		else:
			audio.play()
		$Gyro/Timer.start()



func _on_stop_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		act_status(0)

func _on_pause_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if audio.stream_paused == true:
			act_status(2)
		else:
			act_status(1)

func _on_play_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if audio.playing == false:
			act_status(2)

func _on_audio_finished():
	act_status(0)
