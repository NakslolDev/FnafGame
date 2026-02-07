extends Node

@onready var animatronic := Global.killed_by

var scene_dead = load("res://Escenas/Menu/DeadScene/Dead_Scene.tscn") as PackedScene
var scene_minigame = load("res://Escenas/Shift/minigame.tscn") as PackedScene

func _ready() -> void:
	print("Current anim: ", animatronic)
	print("Enter -> complete | Space -> Save | Esc to exit")

func _input(event: InputEvent) -> void:
	var decision: Global.Estado
	if event.is_action_pressed("Enter"):
		decision = Global.Estado.COMPLETADO
	elif event.is_action_pressed("Space"):
		decision = Global.Estado.SALVADO
	elif event.is_action_pressed("Esc"):
		decision = Global.Estado.STANDBY
	else:
		return
	Global.dm[animatronic] = decision
	exit(decision)
	#print(event, " | ", decision)


func exit(decision: Global.Estado):
	
	Global.escena_previa = "death_minigame"
	
	var dead_scene: Callable = func():
		get_tree().change_scene_to_packed(scene_dead)
	
	var minigame_scene: Callable = func():
		get_tree().change_scene_to_packed(scene_minigame)
	
	if decision == Global.Estado.STANDBY:
		dead_scene.call_deferred()
	
	else:
		Global.guardar_death_minigames() # Es importante guardar aqui.
		if decision == Global.Estado.COMPLETADO:
			Global.just_death_min = "k" + animatronic
		if decision == Global.Estado.SALVADO:
			Global.just_death_min = "s" + animatronic
		Global.m_entering = true
		Global.minigame_starts()
		minigame_scene.call_deferred()
