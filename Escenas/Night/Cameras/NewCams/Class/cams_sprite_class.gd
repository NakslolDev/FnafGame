extends Sprite2D
class_name CamSprite

@onready var base: CamBase = get_parent()

enum bool_state {PASS, FALSE, TRUE}
enum animatronic {BONNIE, CHICA, FREDDY, FOXY} # principalmente para checkear las alucinaciones

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
		FXroom.KITCHEN: return 2
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

func _check_foxy_room_values():
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
	
	if not _bonnie(): return
	if not _chica(): return
	if not _freddy(): return
	if not _foxy(): return
	
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


func _bonnie() -> bool:
	if bonnie == Bpos.PASS: 
		return true
	
	if _check_bonnie_pos(Bonnie.position): return true
	
	for alucination in base.alucinaciones:
		if alucination["animatronic"] != animatronic.BONNIE:
			continue
		if _check_bonnie_pos(alucination["position"]): return true
	
	return false

func _check_bonnie_pos(pos: String) -> bool:
	match pos:
		"S": if bonnie == Bpos.SCENARY: return true
		"0": if bonnie == Bpos.ZERO: return true
		"1": if bonnie == Bpos.ONE: return true
		"2": if bonnie == Bpos.TWO: return true
		"3": if bonnie == Bpos.THREE: return true
		"4": if bonnie == Bpos.FOUR: return true
		"5": if bonnie == Bpos.FIVE: return true
		"PI": if bonnie == Bpos.LEFT_DOOR: return true
		"office": if bonnie == Bpos.OFFICE: return true
	return false


func _chica() -> bool:
	if chica == Cpos.PASS:
		return true
	
	if _check_chica_pos(Chica.position): return true
	
	for alucination in base.alucinaciones:
		if alucination["animatronic"] != animatronic.CHICA:
			continue
		if _check_chica_pos(alucination["position"]): return true
	
	return false

func _check_chica_pos(pos: String) -> bool:
	match pos:
		"S": if chica == Cpos.SCENARY: return true
		"1": if chica == Cpos.ONE: return true
		"2": if chica == Cpos.TWO: return true
		"3": if chica == Cpos.THREE: return true
		"4": if chica == Cpos.FOUR: return true
		"5": if chica == Cpos.FIVE: return true
		"6": if chica == Cpos.SIX: return true
		"PD": if chica == Cpos.RIGHT_DOOR: return true
		"Office": if chica == Cpos.OFFICE: return true
	return false


func _freddy() -> bool:
	if freddy == Fpos.PASS:
		return true
	
	if _check_freddy_pos(Freddy.path, Freddy.position): return true
	
	for alucination in base.alucinaciones:
		if alucination["animatronic"] != animatronic.FREDDY:
			continue
		if _check_freddy_pos(alucination["path"], alucination["position"]): return true
	
	return false

func _check_freddy_pos(path: int, pos: String) -> bool:
	match path:
		1:
			if pos == "1" and freddy == Fpos.P1_ONE: return true
			if pos == "2" and freddy == Fpos.P1_TWO: return true
			if pos == "3" and freddy == Fpos.P1_THREE: return true
			if pos == "PI" and freddy == Fpos.P1_LEFT_DOOR: return true
		2:
			if pos == "1" and freddy == Fpos.P2_ONE: return true
			if pos == "2" and freddy == Fpos.P2_TWO: return true
			if pos == "3" and freddy == Fpos.P2_THREE: return true
			if pos == "4" and freddy == Fpos.P2_FOUR: return true
			if pos == "PD" and freddy == Fpos.P2_RIGHT_DOOR: return true
	
	if pos == "S" and freddy == Fpos.SCENARY: return true # están fuera por si path no está actualizado correctamente 
	if pos == "0" and freddy == Fpos.ZERO: return true
	if pos == "T1" and freddy == Fpos.TRANSITION_1: return true
	if pos == "T2" and freddy == Fpos.TRANSITION_2: return true
	if pos == "office" and freddy == Fpos.OFFICE: return true
	
	return false


func _foxy() -> bool:
	if foxy_room == FXroom.PASS: return true
	
	if _check_foxy_pos(Foxy.room, Foxy.position): return true
	
	for alucination in base.alucinaciones:
		if alucination["animatronic"] != animatronic.FOXY:
			continue
		if _check_foxy_pos(alucination["room"], alucination["position"]): return true
	
	return false

func _check_foxy_pos(room: String, pos: int) -> bool:
	if foxy_pos != pos: return false
	match foxy_room:
		FXroom.MAIN:
			if room == "main": return true
		FXroom.ARCADE:
			if room == "arcade": return true
		FXroom.PARTS_AND_SERVICES:
			if room == "pas": return true
		FXroom.ENTRANCE:
			if room == "entrance": return true
		FXroom.KITCHEN:
			if room == "kitchen": return true
		FXroom.ALMACEN:
			if room == "almacen": return true
		FXroom.CLOSET:
			if room == "closet": return true
		FXroom.LEFT_HALL:
			if room == "lhall": return true
		FXroom.RIGHT_HALL:
			if room == "rhall": return true
		FXroom.OFFICE:
			if room == "office": return true
		FXroom.DUC_1:
			if room == "Duc1": return true
		FXroom.DUC_2:
			if room == "Duc2": return true
		FXroom.DUC_3:
			if room == "Duc3": return true
		FXroom.DUC_4:
			if room == "Duc4": return true
		FXroom.DUC_5:
			if room == "Duc5": return true
		FXroom.DUC_6:
			if room == "Duc6": return true
		FXroom.DUC_7:
			if room == "Duc7": return true
		FXroom.DUC_8:
			if room == "Duc8": return true
	return false


func _ready():
	_check_foxy_room_values()
