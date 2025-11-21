extends Node2D

func _ready():
	act()

func act():
	$Door_office_locked.position.y = 100
	$Door_office_unlocking.position.y = 100
	$Door_office_unlocked.position.y = 100
	if Global.mapa["door_office_open"]:
		$Door_office_unlocked.position.y = 0
	elif Global.inventario["key"]:
		$Door_office_unlocking.position.y = 0
	else:
		$Door_office_locked.position.y = 0
