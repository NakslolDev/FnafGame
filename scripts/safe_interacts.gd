extends Node2D

func _ready():
	act()

func act():
	
	$Safe_pop_up.scale = Vector2.ZERO
	$Safe_internal_organs.scale = Vector2.ZERO
	$Safe_more_organs.scale = Vector2.ZERO
	$Safe_unsafe.scale = Vector2.ZERO
	$Chickend_safe.scale = Vector2.ZERO
	
	if Global.mapa["safe_open"]:
		if not Global.inventario["files"]:
			$Safe_internal_organs.scale = Vector2.ONE
		elif not Global.inventario["usb_key"]:
			$Safe_more_organs.scale = Vector2.ONE
		else:
			$Safe_unsafe.scale = Vector2.ONE
	elif Global.mapa["safe_opened_by_animatronic"]:
		$Chickend_safe.scale = Vector2.ONE
	else:
		$Safe_pop_up.scale = Vector2.ONE
