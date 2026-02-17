extends Node

@export var cams: Node2D

## set alucinaciones

enum animatronic {BONNIE, CHICA, FREDDY, FOXY}
var alucinaciones: Array[Dictionary]
var cam_counter: int = 0

@export var alucinations_cam_flick_limit := 10 # cantidad de veces que abres y cierras las cams antes de actualizar las alucianciones

func _ready():
	for cam in cams.cameras:
		cam.alucinaciones = alucinaciones

func alucinations(cam_active: bool): #manages alucination when opening and closing the cams
	
	if not cam_active:
		return # de momento no hago nada al bajar las camaras
	
	var insanity = Global.insanity
	if insanity < 0:
		alucinaciones.clear()
	if insanity < 100:
		return
	
	if cam_counter <= randi_range(0, 5):
		_make_alucinations(insanity)
		cam_counter = alucinations_cam_flick_limit
	
	cam_counter -= 1

func _make_alucinations(insanity: int):
	var n := _intensity_to_number_of_al(insanity)
	
	alucinaciones.clear()
	
	for i in n:
		
		var anim: animatronic = animatronic.values().pick_random()
		
		# BONNIE
		if anim == animatronic.BONNIE:
			var pos = ["S", "0", "1", "2", "3", "4", "5", "PI"].pick_random()
			
			alucinaciones.append({
				"animatronic": anim,
				"position": pos
			})
		
		# CHICA
		elif anim == animatronic.CHICA:
			var pos = ["S", "1", "2", "3", "4", "5", "6", "PD"].pick_random()
			
			alucinaciones.append({
				"animatronic": anim,
				"position": pos
			})
		
		# FREDDY
		elif anim == animatronic.FREDDY:
			var path := randi_range(0, 2)
			var pos: String
			
			match path:
				0:
					pos = ["S", "0", "T1", "T2"].pick_random()
				1:
					pos = ["1", "2", "3", "PI"].pick_random()
				2:
					pos = ["1", "2", "3", "4", "PD"].pick_random()
			
			alucinaciones.append({
				"animatronic": anim,
				"path": path,
				"position": pos
			})
		
		# FOXY
		elif anim == animatronic.FOXY:
			var room: String = [
				"main",
				"arcade",
				"pas",
				"entrance",
				"kitchen",
				"almacen",
				"closet",
				"lhall",
				"rhall",
				"Duc1",
				"Duc2",
				"Duc3",
				"Duc4",
				"Duc5",
				"Duc6",
				"Duc7",
				"Duc8"
			].pick_random()
			
			var min_pos := _get_min_pos_for_room(room)
			var max_pos := _get_max_pos_for_room(room)
			var pos := randi_range(min_pos, max_pos)
			
			alucinaciones.append({
				"animatronic": anim,
				"room": room,
				"position": pos
			})
	
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2))
	print("made alucinations (", alucinaciones.size(),"): ",)
	for _print in alucinaciones:
		print(_print)
	print("")

func _intensity_to_number_of_al(x: int) -> int:
	# normalizamos x: 100 → 0, 500 → 1
	var t := float(x - 100) / float(500 - 100)
	t = clamp(t, 0.0, 1.0)

	# curva suavizada: sube lento al principio, máximo cerca de 1
	var base := 8.0 * (1.0 - exp(-1.2 * t))  # factor reducido para suavizar

	# aleatoriedad proporcional, ligeramente más baja para valores medios
	var randomness := base * 0.2
	var result := base + randf_range(-randomness, randomness)

	# clamp final
	result = clamp(result, 0.0, 8.0)
	
	result += 1 # me gusta esta curba, pero los valores son un poco bajos...
	return roundi(result)


func _get_min_pos_for_room(room: String) -> int:
	match room:
		"pas": return 0
		"lhall": return 0
		"rhall": return 0
		"Duc5": return 0
		"Duc8": return 0
		_: return 1

func _get_max_pos_for_room(room: String) -> int:
	match room:
		"main": return 5
		"arcade": return 4
		"pas": return 3
		"entrance": return 1
		"kitchen": return 1
		"almacen": return 2
		"closet": return 1
		"lhall": return 2
		"rhall": return 2
		"Duc1": return 3
		"Duc2": return 5
		"Duc3": return 4
		"Duc4": return 4
		"Duc5": return 6
		"Duc6": return 4
		"Duc7": return 2
		"Duc8": return 7
		_: return 1

## everything else

func flashlight(active_cam: int):
	
	var new_alucinaciones: Array[Dictionary] = []
	
	for alucination: Dictionary in alucinaciones:
		
		match alucination["animatronic"]:
			
			animatronic.BONNIE:
				if cams.get_cam_from_movement_b(alucination["position"]) != active_cam:
					new_alucinaciones.append(alucination)
			
			animatronic.CHICA:
				if cams.get_cam_from_movement_c(alucination["position"]) != active_cam:
					new_alucinaciones.append(alucination)
			
			animatronic.FREDDY:
				if cams.get_cam_from_movement_fd(alucination["position"], alucination["path"]) != active_cam:
					new_alucinaciones.append(alucination)
			
			animatronic.FOXY:
				if cams.get_cam_from_movement_fx(alucination["position"], alucination["room"]) != active_cam:
					new_alucinaciones.append(alucination)
	
	alucinaciones.assign(new_alucinaciones)
