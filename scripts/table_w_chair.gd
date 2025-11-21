extends Node2D

func switch_up_down(witch: String):
	if witch.begins_with("Pick"):
		$Chair.visible = false
		Global.inventario["chair"] = false
	else:
		$Chair.visible = true
		Global.inventario["chair"] = true
