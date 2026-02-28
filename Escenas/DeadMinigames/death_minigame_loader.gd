extends Node

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

@onready var animatronic := Global.killed_by

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
	print(event, " | ", decision)


func exit(decision: Global.Estado):
	
	if decision == Global.Estado.STANDBY:
		scene_handler.change_to_death_scene()
	
	else:
		if decision == Global.Estado.COMPLETADO:
			Global.just_death_min = "k" + animatronic
		if decision == Global.Estado.SALVADO:
			Global.just_death_min = "s" + animatronic
		scene_handler.change_to_shift()
