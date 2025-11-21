extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		$"../..".change_door(true)


func _on_body_exited(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		$"../..".change_door(false)
