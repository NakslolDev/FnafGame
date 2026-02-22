extends VBoxContainer

var debug := Global.debug 

func _ready():
	sync()

func sync():
	debug = Global.debug 
	$CheckBox_prevent_save.button_pressed = debug["prevent_save"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_Invencibility.button_pressed = debug["cheats"]["invencibility"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_Timeless.button_pressed = debug["cheats"]["timeless"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_ultra_agresive.button_pressed = debug["cheats"]["ultra_agresive"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_Infinite_Batery.button_pressed = debug["cheats"]["infinite_light"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_Lights_consume.button_pressed = debug["cheats"]["lights_consume"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_animatronic_map.button_pressed = debug["cheats"]["animatronic_map"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_see_light_batery.button_pressed = debug["cheats"]["see_light_batery"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_see_time_always.button_pressed = debug["cheats"]["see_time_always"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_see_insanity.button_pressed = debug["cheats"]["see_insanity"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_tick_count.button_pressed = debug["cheats"]["tick_count"]
	$MarginContainer_cheats/VBoxContainer/max_consumption/SpinBox_max_consumption.value = debug["cheats"]["max_consumption"]
	$MarginContainer_cheats/VBoxContainer/night_duration/SpinBoxt_night_duration.value = debug["cheats"]["night_duration"]
	$MarginContainer_cheats/VBoxContainer/tick_rate/SpinBoxt_tick_rate.value = debug["cheats"]["tick_rate"]
	$MarginContainer_cheats/VBoxContainer/CheckBox_Instant_win.button_pressed = debug["cheats"]["instawin"] 
	

func _on_check_box_prevsafe_toggled(toggled_on: bool) -> void:
	debug["prevent_save"] = toggled_on

func _on_check_box_invencibility_toggled(toggled_on: bool) -> void:
	debug["cheats"]["invencibility"] = toggled_on

func _on_check_box_timeless_toggled(toggled_on: bool) -> void:
	debug["cheats"]["timeless"] = toggled_on

func _on_check_box_ultra_agresive_toggled(toggled_on: bool) -> void:
	debug["cheats"]["ultra_agresive"] = toggled_on

func _on_check_box_infinite_batery_toggled(toggled_on: bool) -> void:
	debug["cheats"]["infinite_light"] = toggled_on

func _on_check_box_lights_consume_toggled(toggled_on: bool) -> void:
	debug["cheats"]["lights_consume"] = toggled_on

func _on_check_box_animatronic_map_toggled(toggled_on: bool) -> void:
	debug["cheats"]["animatronic_map"] = toggled_on

func _on_check_box_see_light_batery_toggled(toggled_on: bool) -> void:
	debug["cheats"]["see_light_batery"] = toggled_on

func _on_check_box_see_time_always_toggled(toggled_on: bool) -> void:
	debug["cheats"]["see_time_always"] = toggled_on

func _on_check_box_see_insanity_toggled(toggled_on: bool) -> void:
	debug["cheats"]["see_insanity"] = toggled_on

func _on_check_box_tick_count_toggled(toggled_on: bool) -> void:
	debug["cheats"]["tick_count"] = toggled_on

func _on_spin_box_max_consumption_value_changed(value: float) -> void:
	debug["cheats"]["max_consumption"] = value

func _on_spin_boxt_night_duration_value_changed(value: float) -> void:
	debug["cheats"]["night_duration"] = value

func _on_spin_boxt_tick_rate_value_changed(value: float) -> void:
	debug["cheats"]["tick_rate"] = value

func _on_check_box_instant_win_toggled(toggled_on: bool) -> void:
	debug["cheats"]["instawin"] = toggled_on


func _on_unlock_cn_pressed() -> void:
	Global.custom_night = true
