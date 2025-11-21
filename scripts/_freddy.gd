extends Node

var AI_level: int
var tick_count: int
var lock_movement: bool
var door_fail_count: int
var cam_look_count: int
var cam_stun: int
var path_to_take: int # esta variable determina que comportamiento va a tomar freddy
var puerta_atack: bool

#Path 0 -> S, 0, T1, T2, office
#Path 1 -> 1, 2, 3, PI
#Path 2 -> 1, 2, 3, 4, PD
var path := 0
var position := "S"
var last_path := 0
var last_position := "S"

signal movement(to_pos: String, to_path: int, from_pos: String, from_path: int)

#info
var camara: int
var cam_activa: bool
var seen := false
var cam_light := false
var looking_left_on_specificly_cam_3: bool
var girado := false
var door_I_closed := false
var door_D_closed := false

func reset():
	tick_count = 0
	lock_movement = false
	door_fail_count = 0
	cam_look_count = 0
	cam_stun = 0
	path_to_take = 0
	puerta_atack = false
	path = 0
	position = "S"
	last_path = 0
	last_position = "S" 
	door_I_closed = false
	door_D_closed = false
	girado = false
	camara = 1
	cam_activa = false
	cam_light = false
	print_rich("[color=967B63]Freddy reset...")


func tick():
	
	if AI_level == 0 or position == "office":
		return
	
	if looking_at_me():
		
		if not seen:
			print_rich("[color=967B63]GOTCHA!")
		seen = true
		
		if position != "S" and position != "0":
			cam_look_count += 1
		
		if cam_light:
			if cam_look_count < 20:
				cam_look_count = 20
			cam_stun = 20 - AI_level
			if tick_count > AI_level:
				tick_count = AI_level
			print_rich("[color=967B63]Freddy BIG stuned: from ", position)
		else: # no stunea, solo evita que avance el tick count
			print_rich("[color=967B63]Freddy stop tick count: from ", position)
		
		if cam_look_count >= 30 and position != "S" and position != "0":
			var ipos = str_to_var(position)
			if ipos == null: # creamos otra ves ipos
				ipos = 99999
			move_back(ipos)
			cam_look_count = 0
		
		return
	
	elif looking_at_me(false) and seen and cam_look_count > 0: # lo importante es que exista el elif para que no entre en el else y el return
		if cam_look_count > 20:
			cam_look_count = 20
		if randf_range(0, 49 - AI_level) < 10: # 1/5 IA 0, 1/3 IA 20... Lo que se traduce en 20 segundos ia 0, 12 en IA 20
			cam_look_count -= 1 # ahora me he quedado en que está quieto un rato, pero va descendiendo
			print_rich("[color=967B63]Freddy is awakening... with cam closed: from ", position) # al principio havia hecho que se quedase quieto
		else:
			print_rich("[color=967B63]Freddy stop tick count with cam closed: from ", position) # al principio havia hecho que se quedase quieto
		return
	
	else:
		if cam_stun > 0:
			cam_stun -= 1
		cam_look_count = 0
	
	if cam_stun > 0:
		return
	
	var tick_count_limit: int
	
	if Global.debug["cheats"]["ultra_agresive"]:
		tick_count_limit = 1
	elif position != "PI" and position != "PD":
		tick_count_limit = 30
	elif puerta_atack:
		tick_count_limit = 1
	else:
		tick_count_limit = 15
	
	tick_count += 1
	if tick_count == tick_count_limit:
		tick_count = 0
		movement_oportunity(Global.noche, AI_level)

func looking_at_me(cam_open_required := true):
	
	if not Global.energia["Camaras"]:
		seen = false
		return
	
	if not cam_activa and cam_open_required:
		return false
	
	if camara == 1 and position == "S":
		return true
	if camara == 2 and position == "1" and path == 1:
		return true
	if camara == 3 and position == "T1" and looking_left_on_specificly_cam_3:
		return true
	if camara == 3 and position == "1" and path == 2 and not looking_left_on_specificly_cam_3:
		return true
	if camara == 4 and position == "2" and path == 2:
		return true
	if camara == 5 and position == "3" and path == 2:
		return true
	if camara == 7 and position == "2" and path == 1:
		return true
	if camara == 9 and position == "T2":
		return true
	if camara == 10 and position == "3" and path == 1:
		return true
	if camara == 11 and position == "PI":
		return true
	if camara == 12 and position == "4" and path == 2:
		return true
	if camara == 13 and position == "PD":
		return true
	return false # si falla todas, false

func movement_oportunity(_night, AI):
	
	var movement_hit := false
	var ipos = str_to_var(position)
	if ipos == null:
		ipos = 99999
	var rand_MO
	
	if path_to_take == 0:
		path_to_take = randi_range(1,2)
		print_rich("[color=967B63]PATH DECIDED: ", path_to_take)
	
	if (path_to_take == 1 and position != "PI") or (path_to_take == 2 and position != "PD"):
		door_fail_count = 0
		puerta_atack = false
		rand_MO = randi_range(0, 20) # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
		if AI > rand_MO:
			movement_hit = true
	
	elif (position == "PI" and not door_I_closed) or (position == "PD" and not door_D_closed):
		rand_MO = randi_range(0, 20) # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
		if AI > rand_MO:
			puerta_atack = true
		
		if puerta_atack and (cam_activa or girado): # te entra siempre si tienes la cam activa o mires hacia atras
			movement_hit = true
		elif puerta_atack:
			door_fail_count += 1
	
	else:
		rand_MO = randi_range(0, 20) # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
		if AI > rand_MO:
			puerta_atack = true
		
		if puerta_atack:
			door_fail_count += 1
	
	if puerta_atack:
		var rand_give_up = randi_range(0, 5000)
		if door_fail_count * AI / 5.0 > rand_give_up:
			print_rich("[color=967B63]Freddy gave up: from ", position)
			puerta_atack = false
			movement_hit = true # siempre se va cuando se da por vencido
			if path_to_take == 1:
				path_to_take = 2
			else:
				path_to_take = 1
	
	if lock_movement == true:
		if position == "PI" or position == "PD": # comprueva que acaba de llegar a la puerta. Si lo paras, si que se vuelve
			movement_hit = false
			puerta_atack = false 
			lock_movement = false
	
	if movement_hit:
		move(ipos, AI)
	elif position == "PD" or position == "PI" and puerta_atack:
		print_rich("[color=967B63]Freddy movement puerta_atack: from ", position)
	else:
		print_rich("[color=967B63]Freddy movement no: from ", position)

func move(ipos, AI):
	
	seen = false
	
	last_position = position
	last_path = path
	
	if position == "S":
		position = "T1"
		path = 0 # en principio no es necesario
	
	elif position == "0": # con IA alta, mas probable de no pasar por T1 desde 0
		if path_to_take == 1:
			if AI > randi_range(0, 20):
				position = "1"
				path = 1
			else:
				position = "T1"
				path = 0
		else:
			position = "T1"
			path = 0
	
	elif position == "T1":
		position = "1"
		path = path_to_take # path to take es o 1 o 2. Es el camino al que se dirige
	
	elif position == "T2":
		if path_to_take == 1:
			position = "3"
		else:
			position = "4"
		path = path_to_take # path to take es o 1 o 2. Es el camino al que se dirige
	
	elif ipos < 10: # esto comprueva si está en una posicion numerica. Si position no es un numero, ipos = 99999
		
		if path == path_to_take: # si está en el camino correcto, avanza
			if path == 1:
				if ipos == 3:
					position = "PI"
				else:
					position = str(ipos + 1)
			else: # path 2
				if ipos == 4:
					position = "PD"
				else:
					position = str(ipos + 1)
		
		else: # si está en el camino incorrecto
			if path == 1:
				if ipos == 3:
					position = "T2"
					path = 0
				else:
					position = str(ipos + 1)
			else: # path 2
				if ipos == 4:
					position = "T2"
					path = 0
				elif ipos == 1: # es más rápido
					position = "T1"
					path = 0
				else:
					position = str(ipos + 1)
	
	elif position == "PI":
		if path_to_take == path:
			position = "office"
			path = 0
		else:
			position = "3"
	
	elif position == "PD":
		if path_to_take == path:
			position = "office"
			path = 0
		else:
			position = "4"
	
	if position == "T2":
		if randi_range(0, 1) == 1:
			path_to_take = 0 # 50% de resetear el camino cuando está en T2, lo que significa 25% de posibilidades de volver a la misma puerta
	
	if position == "PI":
		lock_movement = true # bloquea el primer intento siempre
	
	print_rich("[color=967B63]Freddy movement yes: from ", last_position, " to ", position)
	emit_signal("movement", position, path, last_position, last_path)

func move_back(ipos):
	
	tick_count = 0
	last_position = position
	last_path = path
	
	if position == "T1":
		position = "0"
		path = 0
		path_to_take = 0
	
	elif ipos < 10:
		
		if ipos == 1:
			position = "T1"
			path = 0
			path_to_take = 0
		else:
			position = str(ipos - 1)
			path_to_take = path # resetea el path to take para que vaya directo a la puerta
	
	elif position == "T2":
		if path_to_take == 1:
			position = "3"
			path = 1
		else:
			position = "4"
			path = 2
	
	elif position == "PD":
		position = "4"
	elif position == "PI":
		position = "3"
	
	print_rich("[color=967B63]Freddy movement back: from ", last_position, " to ", position)
	emit_signal("movement", position, path, last_position, last_path)
