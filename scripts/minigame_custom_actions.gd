extends Node2D

@export var father: Node

func do_custom_action(action: String, read: int):
	
	if action.ends_with("chair_w_text"):
		switch_chair(action)
	
	elif action == "Pick_key_w_text":
		Global.inventario["key"] = true
	
	
	elif action == "Loot_safe_w_text":
		Global.inventario["files"] = true
	elif action == "Keep_looting_safe_w_text":
		Global.inventario["safe_usb_key"] = true
	elif action == "loot_empty_safe_w_text":
		Global.inventario["life_savings"] = true
	
	
	elif action == "Start_computer_w_text":
		Global.mapa["computer_working"] = true
	elif action == "Get_program_w_text":
		Global.inventario["exe"] = true
		Global.mapa["computer_working"] = false
	
	
	elif action == "Sign_in_w_text":
		if read == 1:
			Global.mapa["signed_in"] = true
			print("Good luck!")
	
	
	elif action == "Open_door_w_text":
		Global.mapa["door_office_open"] = true

func switch_chair(action):
	if not father.transition_out:
		$"../Coliders/Pick_up_chair".switch_up_down(action)
		$"../YSort/Table_w_chair".switch_up_down(action)
