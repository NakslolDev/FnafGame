extends Node

#AI variables
var AI_level: int
var tick_count := 0
var gotcha := 0
var gotcha_lights := false
var lock_movement := false
var door_fail_count := 0 # en el caso de chica, le da igual si tienes la puerta abierta o cerrada, se moverá igual (excepto a donde)
var door_soft_focus := false

#S, 1, 2, 3, 4, 5, 6, PD, Office
var position = "S"
var last_position = "S"

#info
var door_closed := false
var door_closed_log := false # esto es para hacer que cuando abras la puerta y esté ahi, no te pueda saltar directamente. Tengo 2 opciones: lock_movement o reset tick_count 
var luces: bool # luces de la oficina
var camara: int
var cam_activa: bool
var watching_cam_6_when_i_am_there_and_it_is_night_5_and_i_am_attempting_to_open_the_safe := false


signal movement(to: int, from: int)

func reset():
	tick_count = 0
	gotcha = 0
	lock_movement = false
	door_fail_count = 0
	position = "S"
	last_position = "S"
	door_closed = false
	door_soft_focus = false

func tick():
	
	if AI_level == 0  or position == "office":
		return
	
	var tick_count_limit: int
	
	if door_closed:
		door_closed_log = true
	else:
		if door_closed_log == true: # resetea los ticks
			@warning_ignore("integer_division")
			tick_count = 0 + (AI_level / 2) # en niveles altos te deja menos tiempo segundo
			door_closed_log = false
	
	if gotcha > 0:
		if position == "PD":
			if door_soft_focus == true or (camara == 11 and cam_activa) or door_closed:
				gotcha = 0
				print_rich("[color=yellow]GOTCHA!")
				if door_soft_focus == true:
					gotcha_lights = true
		else:
			gotcha_lights = false
			gotcha = 0
	
	if Global.debug["cheats"]["ultra_agresive"]:
		tick_count_limit = 1
	elif position != "PD":
		if (Global.noche == 5 and Global.mapa["door_office_open"] and not Global.mapa["safe_open"]) and position == "6": # la condicion es un poco larga, pero asi es más organico. Reacciona al mapa y no a una varable
			tick_count_limit = 5 * 20 # 20 segundos
			print_rich("[color=yellow]WAITING: ", tick_count, " of ", tick_count_limit)
		else:
			tick_count_limit = 25
	else:
		tick_count_limit = 15
	
	tick_count += 1
	
	if tick_count >= tick_count_limit:
		
		if watching_cam_6_when_i_am_there_and_it_is_night_5_and_i_am_attempting_to_open_the_safe:
			print_rich("[color=yellow]still hearing, be pacient")
			return # no dejo que se mueva si estás en esa camara mientras intenta abrir
		
		tick_count = 0
		movement_oportunity(Global.noche, AI_level)


func movement_oportunity(_noche: int, AI: int, always_do := false):
	
	var movement_hit := false
	var rand_MO
	if Global.energia["Luces"]:
		luces = true
	else:
		luces = false
	
	if position != "PD":
		door_fail_count = 0
		rand_MO = randi_range(0, 20) # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
		if AI > rand_MO or always_do: # cuando termina de abrir la caja, quiero que siempre se vaya
			movement_hit = true
	
	elif not door_closed:
		rand_MO = randi_range(0, 20) # siempre acierta en nivel 20
		if AI > rand_MO:
			movement_hit = true
		else:
			door_fail_count += 1
		if door_fail_count == 5: # tope de fallos en la puerta. Que salte justo cuando d_f_c = 5 y no en el siguiente MO es intencional
			movement_hit = true
	else:
		rand_MO = randi_range(0, 20 + AI) # en niveles bajos salga más rapido aun. Casi siempre. En altos 50-50
		if rand_MO < 30:
			movement_hit = true
		else:
			door_fail_count += 1
		if door_fail_count == 5: # tope de fallos en la puerta. Que salte justo cuando d_f_c = 5 y no en el siguiente MO es intencional
			movement_hit = true
	
	
	if lock_movement == true:
		if position == "PD": # comprueva que acaba de llegar a la puerta. Si lo paras, si que se vuelve
			if not door_closed:
				movement_hit = false
				if gotcha > 0:
					gotcha -= 1
				else:
					lock_movement = false
			else:
				lock_movement = false
	
	if movement_hit:
		move(AI)
	else:
		print_rich("[color=yellow]Chica movement no: from ", position)
	

func move(AI):
	
	var true_last = last_position
	last_position = position # poniendolo aqui en vez de al final consigo que se mantenga fiel mientras no se mueve
	var repetir := true
	
	while repetir == true: # para que sea menos probable que vuelva a la misma casilla de donde vino
		
		position = last_position # si no avanza varias veces
		
		if position == "S":
			position = "1"
		elif position == "1":
			position = "2"
		elif position == "2":
			position = "3"
		
		elif position == "3":
			var rand_go = randi_range(0, 60) # ~30 % de ir a la 2 con AI = 1, 0% con AI = 20
			if AI + 40 < rand_go:
				position = "2"
			else:
				rand_go = randi_range(0, 1) # 50-50
				if rand_go == 0:
					position = "4"
				else:
					position = "6"
		
		elif position == "4":
			var rand_go = randi_range(1, 200 + AI)
			if rand_go > 150:
				if door_soft_focus:
					position = "6"
				else:
					position = "PD"
			elif rand_go > 100:
				position = "5"
			elif rand_go > 50:
				position = "6"
			else:
				position = "3"
		
		elif position == "5":
			position = "4"
		
		elif position == "6":
			var rand_go = randi_range(1, 150 + AI)
			if rand_go > 100:
				if door_soft_focus:
					position = "4"
				else:
					position = "PD"
			elif rand_go > 50:
				position = "4"
			else:
				position = "3"
		
		elif position == "PD": # desde 50% hasta 25% de que actue como si no puede entrar si las luces están apagadas
			if door_closed or (luces == false and not gotcha_lights and randi_range(0, 20 + AI) < 10):
				if true_last == "4": # nunca volverá a la misma. simplemente pasará de largo
					position = "6"
				else:
					position = "4"
			else:
				position = "office"
		
		
		if true_last == position and position != "PD":
			if randi_range(0, 20 + AI) < 10: # desde 50-50 a 25-75, para que a AI 20 no repita tanto
				repetir = false
		elif true_last == position and position == "PD":
			if randi_range(0, 20 + AI) > 10: # desde 50-50 a 75-25, para que a AI 20 repita más (si va a la puerta)
				repetir = false
		else: # si no vuelve a la posicion anterior, no repetir
			repetir = false
		
	if position == "PD":
		gotcha = 1
		lock_movement = true # bloquea el primer intento siempre
		
	print_rich("[color=yellow]Chica movement yes: from ", last_position, " to ", position)
	emit_signal("movement", position, last_position)
