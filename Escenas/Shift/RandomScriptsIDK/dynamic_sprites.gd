extends Sprite2D
class_name DinamicSprites

@export_group("Nights")
@export var night_0 := true
@export var night_1 := true
@export var night_2 := true
@export var night_3 := true
@export var night_4 := true
@export var night_5 := true
@export var night_6 := true

@export_group("Time_Stamps")
@export var entering := true
@export var exiting := true

@export_group("From_Death_minigame")
@export var none := true
@export var kbonnie := true
@export var kchica := true
@export var kfreddy := true
@export var kfoxy := true
@export var sbonnie := true
@export var schica := true
@export var sfreddy := true
@export var sfoxy := true


@export_group("Inventario")
enum Condition{Omit, Need, Exclude}
@export var key: Condition = Condition.Omit
@export var recorder: Condition = Condition.Omit
@export var screwdriver: Condition = Condition.Omit
@export var pen: Condition = Condition.Omit
@export var files: Condition = Condition.Omit
@export var safe_usb_key: Condition = Condition.Omit
@export var dm_usb_key: Condition = Condition.Omit
@export var exe: Condition = Condition.Omit

@export_group("Mapa")
@export var door_office_open: Condition = Condition.Omit
@export var death_minigames: Condition = Condition.Omit
@export var safe_open: Condition = Condition.Omit
@export var safe_opened_by_animatronic: Condition = Condition.Omit
@export var computer_on: Condition = Condition.Omit
@export var computer_working: Condition = Condition.Omit
@export var computer_failed: Condition = Condition.Omit
@export var signed_in: Condition = Condition.Omit

@export_group("Map Items")
@export var kitchen_water_bottle: Condition = Condition.Omit
@export var main_water_bottle: Condition = Condition.Omit
@export var closet_batteries: Condition = Condition.Omit
@export var pas_batteries: Condition = Condition.Omit
@export var arcade_batteries: Condition = Condition.Omit
@export var almacen_batteries: Condition = Condition.Omit
@export var box_toy: Condition = Condition.Omit
@export var almacen_toy: Condition = Condition.Omit

@export_group("Items")
@export var water_bottle: Condition = Condition.Omit
@export var batteries: Condition = Condition.Omit
@export var door_toy: Condition = Condition.Omit
@export var left_door_toy: Condition = Condition.Omit
@export var right_door_toy: Condition = Condition.Omit


@export_group("Death_minigame_state")
enum dmState{Omit, None, Complete, Saved}
@export var bonnie: dmState = dmState.Omit
@export var chica: dmState = dmState.Omit
@export var freddy: dmState = dmState.Omit
@export var foxy: dmState = dmState.Omit

@onready var minigame: Node = get_tree().get_first_node_in_group("minigame") # curioso, pero bueno, funciona

func _ready():
	check_active()
	minigame.act_sprites.connect(check_active)

func check_active():
	
	visible = true
	
	if Global.noche == -1:
		return
	
	if not get("night_" + str(Global.noche)):
		visible = false
		return
	
	if not (Global.m_entering and entering) and not (!Global.m_entering and exiting):
		visible = false
		return
	
	if not get(Global.just_death_min):
		visible = false
		return
	
	for _key in Global.inventario: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Global.inventario[_key]:
			visible = false
			return
		if value == Condition.Exclude and Global.inventario[_key]:
			visible = false
			return
	
	for _key in Global.mapa: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Global.mapa[_key]:
			visible = false
			return
		if value == Condition.Exclude and Global.mapa[_key]:
			visible = false
			return
	
	for _key in Global.dm: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: dmState = get(_key)
		if value == dmState.Omit: # sobra, pero para que quede más limpio
			continue
		if value == dmState.None and Global.dm[_key] != Global.Estado.STANDBY:
			visible = false
			return
		if value == dmState.Complete and Global.dm[_key] != Global.Estado.COMPLETADO:
			visible = false
			return
		if value == dmState.Saved and Global.dm[_key] != Global.Estado.SALVADO:
			visible = false
			return
	
	for _key in Global.map_items: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Global.map_items[_key]:
			visible = false
			return
		if value == Condition.Exclude and Global.map_items[_key]:
			visible = false
			return
	
	for _key in Items.objects: # Recorre todo el inventario. Si encuentra una discordancia, no va a estar activo
		var value: Condition = get(_key)
		if value == Condition.Omit: # sobra, pero para que quede más limpio
			continue
		if value == Condition.Need and not Items.objects[_key]:
			visible = false
			return
		if value == Condition.Exclude and Items.objects[_key]:
			visible = false
			return
