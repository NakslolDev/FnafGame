extends Area2D

@export_enum("Text", "Begin_night", "Exit_pizza", "Pick_chair_w_text", "Lay_chair_w_text", "Pick_key_w_text", "Safe", "Loot_safe_w_text", "Keep_looting_safe_w_text", "loot_empty_safe_w_text", "start_computer_w_text", "get_program_w_text", "sign_in_w_text", "open_door_w_text")
var action := "Text"
@export var id := ""
var player_in := false
var active

@export var first_read_end_in := 0
var read := false

@export_group("Nights")
@export var night_1 := true
@export var night_2 := true
@export var night_3 := true
@export var night_4 := true
@export var night_5 := true
@export var night_6 := true
@export var true_night_6 := true

@export_group("Time_Stamps")
@export var entering := true
@export var exiting := true

signal do_action(action: String, read: bool)
signal send_id_to_text(id: String, end_in: int, read: bool)

func _ready():
	check_active()

func check_active():
	if Global.noche == -1:
		active = true
		return
	if (get("night_" + str(Global.noche)) and not Global.true_night_6) or (true_night_6 and Global.true_night_6):
		if (Global.m_entering and entering) or (not Global.m_entering and exiting):
			active = true
		else:
			active = false
	else:
		active = false

func _on_body_entered(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		player_in = true

func _on_body_exited(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		player_in = false

func _input(event):
	if not (event.is_action_pressed("interact") and player_in) or not active:
		return
	
	if get_tree().get_root().get_node("Minigame").reading: #uso otro if para que no quede tan largo
		return
	
	if action == "Text":
		emit_signal("send_id_to_text", id, first_read_end_in, read)
	else:
		emit_signal("do_action", action, read)
		if action.ends_with("w_text"):
			emit_signal("send_id_to_text", id, first_read_end_in, read)
	read = true
