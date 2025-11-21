extends Node2D

@export var location := 0

func _ready():
	
	if location == 0:
		var txt_name = name
		txt_name = txt_name.substr((txt_name.length() - 1), 1)
		location = str_to_var(txt_name)
	
	act()

func act():
	if Global.location_key == location:
		act_coliders(true)
	else:
		act_coliders(false)

func act_coliders(key: bool):
	if not key:
		$Picked_Key.scale = Vector2.ZERO
		$Key.scale = Vector2.ZERO
		$No_Key.scale = Vector2.ONE
	else:
		if Global.inventario["key"]:
			$Picked_Key.scale = Vector2.ONE
			$Key.scale = Vector2.ZERO
			$No_Key.scale = Vector2.ZERO
		else:
			$Picked_Key.scale = Vector2.ZERO
			$Key.scale = Vector2.ONE
			$No_Key.scale = Vector2.ZERO
