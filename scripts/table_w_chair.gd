extends Node2D

func switch_up_down(witch: String):
	if witch.begins_with("Pick"):
		$Chair.visible = false
	else:
		$Chair.visible = true
