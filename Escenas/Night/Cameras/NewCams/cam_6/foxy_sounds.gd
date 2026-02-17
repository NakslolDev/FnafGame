extends Node

var active := false
var playing := false
var each := 1

func act_playing():
	if not (active and not playing):
		return
	
	var prev_each := each
	while prev_each == each:
		each = randi_range(1, 5)
	
	$Timer.start(randf_range(0.5, 3.0))

func _on_timer_timeout() -> void:	
	play()

func play():
	playing = true
	if each == 1:
		$Foxy01.play()
	elif each == 2:
		$Foxy02.play()
	elif each == 3:
		$Foxy03.play()
	elif each == 4:
		$Foxy04.play()
	elif each == 5:
		$Foxy05.play()


func _on_foxy_01_finished() -> void:
	playing = false
	act_playing()
func _on_foxy_02_finished() -> void:
	playing = false
	act_playing()
func _on_foxy_03_finished() -> void:
	playing = false
	act_playing()
func _on_foxy_04_finished() -> void:
	playing = false
	act_playing()
func _on_foxy_05_finished() -> void:
	playing = false
	act_playing()
