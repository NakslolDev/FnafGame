extends Node2D

func _ready():
	$Exit_false_Night_6.scale = Vector2.ONE
	act()

func act():
	if Global.inventario["files"] or Global.inventario["exe"]:
		$Exit_false_Night_6.scale = Vector2.ZERO
