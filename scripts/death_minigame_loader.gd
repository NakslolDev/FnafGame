extends Node2D

@onready var animatronic := Global.killed_by

func _ready() -> void:
	print("Current anim: ", animatronic)
	print("Enter -> complete | Space -> Save | Esc to exit")

func _input(event: InputEvent) -> void:
	var decision: int
	if event.is_action_pressed("Enter"):
		decision = 1
	elif event.is_action_pressed("Space"):
		decision = 2
	elif event.is_action_pressed("Esc"):
		decision = 0
	else:
		return
	Global.dm[animatronic] = decision
	exit(decision)


func exit(decision: int):
	
	Global.escena_previa = "death_minigame"
	
	if decision == 0:
		get_tree().change_scene_to_file("res://escenas/Dead_Scene.tscn")
	
	else:
		if decision == 1:
			Global.just_death_min = "k" + animatronic
		if decision == 2:
			Global.just_death_min = "s" + animatronic
		Global.m_entering = true
		Global.minigame_starts()
		get_tree().change_scene_to_file("res://escenas/minigame.tscn")
