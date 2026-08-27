extends Node

@export var father: Node


func do_custom_action(action: String, read: int):
	print("HELLLO: ", action)
	if action.ends_with("_w_text"):
		action = action.substr(0, action.length() - "_w_text".length())
	action = action.to_lower()
	
	if not has_method(action):
		push_error("no function '", action, "' found")
		return
	
	call(action, read)



#--Actions--

func pick_key(_read):
	Global.inventario["key"] = true


func open_door(_read):
	Global.mapa["door_office_open"] = true


func loot_safe(_read):
	Global.inventario["files"] = true

func keep_looting_safe(_read):
	Global.inventario["safe_usb_key"] = true


func start_computer(_read):
	Global.mapa["computer_on"] = true

func start_download(_read):
	Global.mapa["computer_working"] = true

func stop_download(_read):
	Global.mapa["computer_working"] = false

func get_program(_read):
	Global.inventario["exe"] = true
	Global.mapa["computer_working"] = false


func sign_in(_read):
	Global.mapa["signed_in"] = true


func activate_dm_machine(read):
	if read == 2:
		Global.mapa["death_minigames"] = true

func claim_dm_usb(_read):
	Global.inventario["dm_usb_key"] = true


func get_screwdriver(_read):
	Global.inventario["screwdriver"] = true

func get_pen(_read):
	Global.inventario["pen"] = true

func get_closet_batteries(_read):
	Items.objects["batteries"] += 1
	Global.map_items["closet_batteries"] = false

func get_pas_batteries(_read):
	Items.objects["batteries"] += 1
	Global.map_items["pas_batteries"] = false

func get_arcade_batteries(_read):
	Items.objects["batteries"] += 1
	Global.map_items["arcade_batteries"] = false

func get_almacen_batteries(_read):
	Items.objects["batteries"] += 1
	Global.map_items["almacen_batteries"] = false

func get_kitchen_water(_read):
	Items.objects["water_bottle"] += 1
	Global.map_items["kitchen_water_bottle"] = false

func get_main_water(_read):
	Items.objects["water_bottle"] += 1
	Global.map_items["main_water_bottle"] = false

func get_box_toy(_read):
	Items.objects["door_toy"] += 1
	Global.map_items["box_toy"] = false

func get_almacen_toy(_read):
	Items.objects["door_toy"] += 1
	Global.map_items["almacen_toy"] = false

func put_left_toy(_read):
	Items.objects["door_toy"] -= 1
	Items.objects["left_door_toy"] = true

func put_right_toy(_read):
	Items.objects["door_toy"] -= 1
	Items.objects["right_door_toy"] = true
