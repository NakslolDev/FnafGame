extends Sprite2D
class_name CamSprite


@onready var base: CamBase = get_parent()

enum bool_state {PASS, FALSE, TRUE}

@export var active: bool = true

@export var light: bool_state = bool_state.PASS

@export_group("Animatronics")

enum Bpos {PASS, SCENARY, ZERO, ONE, TWO, THREE, FOUR, FIVE, LEFT_DOOR, OFFICE}
@export var bonnie: Bpos = Bpos.PASS

enum Cpos {PASS, SCENARY, ONE, TWO, THREE, FOUR, FIVE, SIX, RIGHT_DOOR, OFFICE}
@export var chica: Cpos = Cpos.PASS

enum Fpos {
	PASS,
	SCENARY,
	ZERO,
	TRANSITION_1,
	TRANSITION_2,
	OFFICE,
	
	P1_ONE,
	P1_TWO,
	P1_THREE,
	P1_LEFT_DOOR,
	
	P2_ONE,
	P2_TWO,
	P2_THREE,
	P2_FOUR,
	P2_RIGHT_DOOR,
}
@export var freddy: Fpos = Fpos.PASS

enum FXroom {
	PASS,
	MAIN,
	ARCADE,
	PARTS_AND_SERVICES,
	ENTRANCE,
	KITCHEN,
	ALMACEN,
	CLOSET,
	LEFT_HALL,
	RIGHT_HALL,
	OFFICE,
	DUC_1,
	DUC_2,
	DUC_3,
	DUC_4,
	DUC_5,
	DUC_6,
	DUC_7,
	DUC_8,
}
@export var foxy_room: FXroom = FXroom.PASS
@export_range(0,7) var foxy_pos: int = 0

func get_min_pos_for_room(room: FXroom) -> int:
	match room:
		FXroom.PASS: return 0
		FXroom.OFFICE: return 0
		FXroom.PARTS_AND_SERVICES: return 0
		FXroom.DUC_5: return 0
		FXroom.DUC_8: return 0
		_: return 1

func get_max_pos_for_room(room: FXroom) -> int:
	match room:
		FXroom.PASS: return 0
		FXroom.MAIN: return 5
		FXroom.ARCADE: return 4
		FXroom.PARTS_AND_SERVICES: return 3
		FXroom.ENTRANCE: return 1
		FXroom.KITCHEN: return 1
		FXroom.ALMACEN: return 2
		FXroom.CLOSET: return 1
		FXroom.LEFT_HALL: return 2
		FXroom.RIGHT_HALL: return 2
		FXroom.OFFICE: return 0
		FXroom.DUC_1: return 3
		FXroom.DUC_2: return 5
		FXroom.DUC_3: return 4
		FXroom.DUC_4: return 4
		FXroom.DUC_5: return 6
		FXroom.DUC_6: return 4
		FXroom.DUC_7: return 2
		FXroom.DUC_8: return 7
		_: return 1

func _chech_foxy_room_values():
	if foxy_room == FXroom.PASS: return
	if foxy_pos < get_min_pos_for_room(foxy_room):
		push_warning("foxy position way too low on: ", self.name, " on cam: ", get_parent().name)
		return
	if foxy_pos > get_max_pos_for_room(foxy_room):
		push_warning("foxy position way too high on: ", self.name, " on cam: ", get_parent().name) 
		return


@export_group("Nights", "night_")
@export var night_0: bool = true
@export var night_1: bool = true
@export var night_2: bool = true
@export var night_3: bool = true
@export var night_4: bool = true
@export var night_5: bool = true
@export var night_6: bool = true

@export_group("misc")

@export_subgroup("key", "key")
@export var key_location: int = 0
@export var key_match: bool_state = bool_state.PASS


func actualice():
	visible = false
	if not active: return
	
	if not_bonnie(): return
	if not_chica(): return
	if not_freddy(): return
	if not_foxy(): return
	
	if not get("night_" + str(Global.noche)): return
	
	match light:
		bool_state.TRUE: 
			if !Global.energia_consumption["Cam_lights"]: return
		bool_state.FALSE: 
			if Global.energia_consumption["Cam_lights"]: return
	
	
	match key_match:
		bool_state.TRUE:
			if key_location != 0 and key_location != Global.location_key: return
		bool_state.FALSE:
			if key_location != 0 and key_location == Global.location_key: return
	
	visible = true

func not_bonnie() -> bool:
	if bonnie == Bpos.PASS: return false
	
	match Bonnie.position:
		"S": if bonnie == Bpos.SCENARY: return false
		"0": if bonnie == Bpos.ZERO: return false
		"1": if bonnie == Bpos.ONE: return false
		"2": if bonnie == Bpos.TWO: return false
		"3": if bonnie == Bpos.THREE: return false
		"4": if bonnie == Bpos.FOUR: return false
		"5": if bonnie == Bpos.FIVE: return false
		"PI": if bonnie == Bpos.LEFT_DOOR: return false
		"office": if bonnie == Bpos.OFFICE: return false
	
	return true

func not_chica() -> bool:
	if chica == Cpos.PASS:
		return false

	match Chica.position:
		"S":       if chica == Cpos.SCENARY: return false
		"1":       if chica == Cpos.ONE: return false
		"2":       if chica == Cpos.TWO: return false
		"3":       if chica == Cpos.THREE: return false
		"4":       if chica == Cpos.FOUR: return false
		"5":       if chica == Cpos.FIVE: return false
		"6":       if chica == Cpos.SIX: return false
		"PD":      if chica == Cpos.RIGHT_DOOR: return false
		"Office":  if chica == Cpos.OFFICE: return false
	
	return true

func not_freddy() -> bool:
	if freddy == Fpos.PASS:
		return false
	
	match Freddy.path:
		1:
			if Freddy.position == "1" and freddy == Fpos.P1_ONE: return false
			if Freddy.position == "2" and freddy == Fpos.P1_TWO: return false
			if Freddy.position == "3" and freddy == Fpos.P1_THREE: return false
			if Freddy.position == "PI" and freddy == Fpos.P1_LEFT_DOOR: return false
		2:
			if Freddy.position == "1" and freddy == Fpos.P2_ONE: return false
			if Freddy.position == "2" and freddy == Fpos.P2_TWO: return false
			if Freddy.position == "3" and freddy == Fpos.P2_THREE: return false
			if Freddy.position == "4" and freddy == Fpos.P2_FOUR: return false
			if Freddy.position == "PD" and freddy == Fpos.P2_RIGHT_DOOR: return false
	
	if Freddy.position == "S" and freddy == Fpos.SCENARY: return false # están fuera por si path no está actualizado correctamente 
	if Freddy.position == "0" and freddy == Fpos.ZERO: return false
	if Freddy.position == "T1" and freddy == Fpos.TRANSITION_1: return false
	if Freddy.position == "T2" and freddy == Fpos.TRANSITION_2: return false
	if Freddy.position == "office" and freddy == Fpos.OFFICE: return false
	
	return true

func not_foxy() -> bool:
	if foxy_room == FXroom.PASS: return false
	
	if foxy_pos != Foxy.position: return true
	
	match foxy_room:
		FXroom.MAIN:
			if Foxy.room == "main": return false
		FXroom.ARCADE:
			if Foxy.room == "arcade": return false
		FXroom.PARTS_AND_SERVICES:
			if Foxy.room == "pas": return false
		FXroom.ENTRANCE:
			if Foxy.room == "entrance": return false
		FXroom.KITCHEN:
			if Foxy.room == "kitchen": return false
		FXroom.ALMACEN:
			if Foxy.room == "almacen": return false
		FXroom.CLOSET:
			if Foxy.room == "closet": return false
		FXroom.LEFT_HALL:
			if Foxy.room == "lhall": return false
		FXroom.RIGHT_HALL:
			if Foxy.room == "rhall": return false
		FXroom.OFFICE:
			if Foxy.room == "office": return false
		FXroom.DUC_1:
			if Foxy.room == "Duc1": return false
		FXroom.DUC_2:
			if Foxy.room == "Duc2": return false
		FXroom.DUC_3:
			if Foxy.room == "Duc3": return false
		FXroom.DUC_4:
			if Foxy.room == "Duc4": return false
		FXroom.DUC_5:
			if Foxy.room == "Duc5": return false
		FXroom.DUC_6:
			if Foxy.room == "Duc6": return false
		FXroom.DUC_7:
			if Foxy.room == "Duc7": return false
		FXroom.DUC_8:
			if Foxy.room == "Duc8": return false
	
	return true

func _ready():
	_chech_foxy_room_values()
