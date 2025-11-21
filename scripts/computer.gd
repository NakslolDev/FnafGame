extends Node2D

func _ready():
	act()

func act():
	$Start_computer.scale = Vector2.ZERO
	$Check_computer.scale = Vector2.ZERO
	$Done_computer.scale = Vector2.ZERO
	$Corrupted_computer.scale = Vector2.ZERO
	$Get_program.scale = Vector2.ZERO
	
	if Global.inventario["exe"]:
		$Done_computer.scale = Vector2.ONE
	elif Global.mapa["computer_failed"]:
		$Corrupted_computer.scale = Vector2.ONE
	elif Global.mapa["computer_working"] and not Global.m_entering:
		$Get_program.scale = Vector2.ONE
	elif Global.inventario["usb_key"]:
		$Start_computer.scale = Vector2.ONE
	else:
		$Check_computer.scale = Vector2.ONE
