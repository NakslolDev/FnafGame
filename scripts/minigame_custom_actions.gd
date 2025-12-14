extends Node2D

@export var father: Node


func do_custom_action(action: String, read: int):
	
	if action.ends_with("_w_text"):
		action = action.substr(0, action.length() - "_w_text".length())
	action = action.to_lower()
	
	if not has_method(action):
		push_error("no function '", action, "' found")
		return
	
	call(action, read)



#--Actions--

func switch_chair(_read):
	if not father.transition_out:
		$"../Coliders/Pick_up_chair".switch_up_down()
		$"../YSort/Table_w_chair".switch_up_down()


func pick_key(_read):
	Global.inventario["key"] = true


func open_door(_read):
	Global.mapa["door_office_open"] = true


func loot_safe(_read):
	Global.inventario["files"] = true

func keep_looting_safe(_read):
	Global.inventario["safe_usb_key"] = true


func start_computer(_read):
	Global.mapa["computer_working"] = true

func get_program(_read):
	Global.inventario["exe"] = true
	Global.mapa["computer_working"] = false


func sign_in(read):
	if read == 1:
		Global.mapa["signed_in"] = true
		print("Good luck!")


func temporal_award_dm_key(_read):
	Global.inventario["dm_usb_key"] = true
