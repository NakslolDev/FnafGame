extends VBoxContainer

var debug := Global.debug 

@export var vbox_mapa: VBoxContainer
@export var vbox_invent: VBoxContainer
@export var vbox_map_items: VBoxContainer


func _ready():
	sync()
	_on_force_combination_toggled(debug["game_state"]["force_combination"])

func sync():
	debug = Global.debug
	$CheckBox_Override.button_pressed = debug["game_state"]["override"]
	$Night/SpinBox_night.value = debug["game_state"]["night"]
	$CheckBox_force_enter.button_pressed = debug["game_state"]["force_enter"]
	$CheckBox_force_exiting.button_pressed = debug["game_state"]["force_exit"]
	$Combination/Force_combination.button_pressed = debug["game_state"]["force_combination"]
	
	var scomb := ""
	for d in debug["game_state"]["combination"]:
		scomb += str(d)
	$Combination/SpinBox_comb.value = int(scomb)
	
	
	
	for key in vbox_invent.get_children():
		var prefix := "CheckBox_"
		var key_id := key.name
		if key_id.begins_with(prefix):
			key_id = key_id.substr(prefix.length())
		key.button_pressed = debug["game_state"]["inventario"][key_id]
	
	for key in vbox_mapa.get_children():
		var prefix := "CheckBox_"
		var key_id := key.name
		if key_id.begins_with(prefix):
			key_id = key_id.substr(prefix.length())
		key.button_pressed = debug["game_state"]["mapa"][key_id]
	
	for key in vbox_map_items.get_children():
		var prefix := "CheckBox_"
		var key_id := key.name
		if key_id.begins_with(prefix):
			key_id = key_id.substr(prefix.length())
		key.button_pressed = debug["game_state"]["map_items"][key_id]
	

func sync_map_in():
	debug = Global.debug
	debug["game_state"]["night"] = Global.noche
	for key in Global.mapa:
		debug["game_state"]["mapa"][key] = Global.mapa[key]
	for key in Global.inventario:
		debug["game_state"]["inventario"][key] = Global.inventario[key]
	sync()

func _on_sync_pressed() -> void:
	sync_map_in()

func _on_check_box_override_toggled(toggled_on: bool) -> void:
	debug["game_state"]["override"] = toggled_on

func _on_check_box_force_enter_toggled(toggled_on: bool) -> void:
	debug["game_state"]["force_enter"] = toggled_on
	if toggled_on and debug["game_state"]["force_exit"]:
		debug["game_state"]["force_exit"] = false
		sync()

func _on_check_box_force_exiting_toggled(toggled_on: bool) -> void:
	debug["game_state"]["force_exit"] = toggled_on
	if toggled_on and debug["game_state"]["force_enter"]:
		debug["game_state"]["force_enter"] = false
		sync()

func _on_spin_box_night_value_changed(value: float) -> void:
	debug["game_state"]["night"] = value

func _on_check_box_office_key_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["key"] = toggled_on

func _on_check_box_recorder_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["recorder"] = toggled_on

func _on_check_box_screwdriver_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["screwdriver"] = toggled_on

func _on_check_box_pen_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["pen"] = toggled_on

func _on_check_box_files_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["files"] = toggled_on

func _on_check_box_usb_key_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["safe_usb_key"] = toggled_on

func _on_check_box_dm_usb_key_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["dm_usb_key"] = toggled_on

func _on_check_box_exe_toggled(toggled_on: bool) -> void:
	debug["game_state"]["inventario"]["exe"] = toggled_on

func _on_check_box_door_office_open_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["door_office_open"] = toggled_on

func _on_check_box_death_minigames_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["death_minigames"] = toggled_on

func _on_check_box_safe_open_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["safe_open"] = toggled_on

func _on_check_box_safe_opened_by_animatronic_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["safe_opened_by_animatronic"] = toggled_on

func _on_check_box_computer_on_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["computer_on"] = toggled_on

func _on_check_box_computer_working_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["computer_working"] = toggled_on

func _on_check_box_computer_failed_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["computer_failed"] = toggled_on

func _on_check_box_signed_toggled(toggled_on: bool) -> void:
	debug["game_state"]["mapa"]["signed_in"] = toggled_on


func _on_force_combination_toggled(toggled_on: bool) -> void:
	debug["game_state"]["force_combination"] = toggled_on
	$Combination/SpinBox_comb.visible = toggled_on
	$Combination/inventario.visible = toggled_on

func _on_spin_box_comb_value_changed(value: float) -> void:
	var result := []
	for c in str(value):
		result.append(int(c))
	debug["game_state"]["combination"] = result


func _on_check_box_kitchen_water_bottle_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["kitchen_water_bottle"] = toggled_on

func _on_check_box_main_water_bottle_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["main_water_bottle"] = toggled_on

func _on_check_box_closet_batteries_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["closet_batteries"] = toggled_on

func _on_check_box_pas_batteries_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["pas_batteries"] = toggled_on

func _on_check_box_arcade_batteries_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["arcade_batteries"] = toggled_on

func _on_check_box_almacen_batteries_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["almacen_batteries"] = toggled_on

func _on_check_box_box_toy_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["box_toy"] = toggled_on

func _on_check_box_almacen_toy_toggled(toggled_on: bool) -> void:
	debug["game_state"]["map_items"]["almacen_toy"] = toggled_on
