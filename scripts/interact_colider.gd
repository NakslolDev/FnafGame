extends Area2D

@export_enum("Custom", "Text", "Begin_night", "Exit_pizza", "Safe")
var action := "Text"

@export_placeholder("'_w_text' for text + action")
var custom_action: String

@export var id := ""
var player_in := false
var active

@export var read_end_in: Array[int]

var read := 0

@export_group("Nights")
@export var night_1 := true
@export var night_2 := true
@export var night_3 := true
@export var night_4 := true
@export var night_5 := true
@export var night_6 := true

@export_group("Time_Stamps")
@export var entering := true
@export var exiting := true

@export_group("Death_minigame")
@export var none := true
@export var bonnie := true
@export var chica := true
@export var freddy := true
@export var foxy := true

@export_group("Inventario")
enum Condition{Omit, Need, Exclude}
@export var key: Condition = Condition.Omit
@export var recorder: Condition = Condition.Omit
@export var screwdriver: Condition = Condition.Omit
@export var bateries: Condition = Condition.Omit
@export var pen: Condition = Condition.Omit
@export var files: Condition = Condition.Omit
@export var safe_usb_key: Condition = Condition.Omit
@export var dm_usb_key: Condition = Condition.Omit
@export var exe: Condition = Condition.Omit

@export_group("Mapa")
@export var door_office_open: Condition = Condition.Omit
@export var safe_open: Condition = Condition.Omit
@export var safe_opened_by_animatronic: Condition = Condition.Omit
@export var computer_on: Condition = Condition.Omit
@export var computer_working: Condition = Condition.Omit
@export var computer_failed: Condition = Condition.Omit
@export var signed_in: Condition = Condition.Omit

signal do_action(action: String, read: int)
signal send_id_to_text(id: String, end_in: Array[int], read: int)

func _ready():
	check_active()

func check_active():
	
	active = true
	
	if Global.noche == -1:
		return
	
	if not get("night_" + str(Global.noche)):
		active = false
		return
	
	if not (Global.m_entering and entering) and not (!Global.m_entering and exiting):
		active = false
		return
	
	if not get(Global.just_death_min):
		active = false
		return
	
	for _key in Global.inventario: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Global.inventario[_key]:
			active = false
			return
		if value == Condition.Exclude and Global.inventario[_key]:
			active = false
			return
	
	for _key in Global.mapa: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Global.mapa[_key]:
			active = false
			return
		if value == Condition.Exclude and Global.mapa[_key]:
			active = false
			return

func _on_body_entered(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		player_in = true

func _on_body_exited(body: Node2D) -> void:
	if str(body).begins_with("Character_Minigame"):
		player_in = false

func _input(event):
	if not (event.is_action_pressed("interact") and player_in) or not active:
		return
	
	if get_tree().get_root().get_node("Minigame").reading or get_tree().get_root().get_node("Minigame").safing: #uso otro if para que no quede tan largo
		return
	
	print("Read: ", read, "  End in: ", read_end_in)
	
	if action == "Custom":
		action = custom_action
	
	if action == "Text":
		emit_signal("send_id_to_text", id, read_end_in, read)
	else:
		emit_signal("do_action", action, read)
		if action.ends_with("w_text"):
			emit_signal("send_id_to_text", id, read_end_in, read)
	if read < read_end_in.size():
		read += 1
	
