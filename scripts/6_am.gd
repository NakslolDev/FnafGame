extends Node2D

@export var velocity_const := 80.0
var transition_out := false
var moving_6 := false
var velocity := 0.0

func _ready():
	$FondoNegro2.modulate.a = 0.0
	$Timer1.start()
	$HallOfFame.play()
	
	if Global.noche == 0 and Global.custom_night_ai == [20, 20, 20, 20]:
		Global.finales["420"] = true
		Global.guardar_progreso()

func _process(delta):
	if moving_6: # movimiento -> 0 -> -475
		$Node2D.position.y -= delta * velocity
		if $Node2D.position.y <= -475.0/2.0 and velocity <= 0:
			moving_6 = false
		if $Node2D.position.y >= -475.0/2.0: # es un poco más de la mitad para que no frene del todo
			velocity += delta * velocity_const
		else:
			velocity -= delta * velocity_const
	
	if transition_out:
		$FondoNegro2.modulate.a += delta/3.0
		if $HallOfFame.volume_linear > delta/9.0:
			$HallOfFame.volume_linear -= delta/9.0
		if $FondoNegro2.modulate.a > 1.0:
			if Global.noche == 0:
				get_tree().change_scene_to_file("res://escenas/custom_night_selecter.tscn")
			else:
				Global.m_entering = false
				Global.minigame_starts()
				get_tree().change_scene_to_file("res://escenas/minigame.tscn")


func _on_timer_1_timeout() -> void:
	moving_6 = true

func _on_hall_of_fame_finished() -> void:
	transition_out = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") or event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space"):
		transition_out = true
