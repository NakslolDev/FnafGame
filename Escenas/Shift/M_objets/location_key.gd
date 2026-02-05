extends Node2D

@export var location := 0

func _ready():
	
	if location == 0:
		location = int(name.substr(name.length() - 1))
	act()

func act():
	if Global.location_key == location:
		$Nokey.scale = Vector2.ZERO
		$Key.scale = Vector2.ONE
	else:
		$Nokey.scale = Vector2.ONE
		$Key.scale = Vector2.ZERO
