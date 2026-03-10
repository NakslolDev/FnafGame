extends VBoxContainer

var debug := Global.debug 

@export var vbox_mapa: VBoxContainer
@export var vbox_invent: VBoxContainer
@export var vbox_map_items: VBoxContainer
@export var combination: HBoxContainer

@export var check_box_override: CheckBox
@export var spin_box_night: SpinBox
@export var check_box_force_enter: CheckBox
@export var check_box_force_exiting: CheckBox
@export var force_combination: CheckBox


func _ready():
	sync()

func sync():
	debug = Global.debug
	check_box_override.button_pressed = debug["game_state"]["override"]
	spin_box_night.value = debug["game_state"]["night"]
	check_box_force_enter.button_pressed = debug["game_state"]["force_enter"]
	check_box_force_exiting.button_pressed = debug["game_state"]["force_exit"]
	force_combination.button_pressed = debug["game_state"]["force_combination"]
	
	for i in range(5):
		combination.get_child(i).value = debug["game_state"]["combination"][i]
	
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

func _on_sync_pressed() -> void:
	Global.sync_debug_to_current()
	sync()

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


func _on_force_combination_toggled(toggled_on: bool) -> void:
	debug["game_state"]["force_combination"] = toggled_on

func _on_spin_box_comb_1_value_changed(value: float) -> void:
	debug["game_state"]["combination"][0] = value

func _on_spin_box_comb_2_value_changed(value: float) -> void:
	debug["game_state"]["combination"][1] = value

func _on_spin_box_comb_3_value_changed(value: float) -> void:
	debug["game_state"]["combination"][2] = value

func _on_spin_box_comb_4_value_changed(value: float) -> void:
	debug["game_state"]["combination"][3] = value

func _on_spin_box_comb_5_value_changed(value: float) -> void:
	debug["game_state"]["combination"][4] = value



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
