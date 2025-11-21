extends Node

#AI variables
var AI_level: int # no necesita reset, pues se asigna en global automaticamente. lo mismo para los demás
var tick_count := 0
var gotcha := 0
var lock_movement := false
var door_fail_count := 0 # uso el positivo para intentos de entrar y el negativo para intentos de irse
var door_soft_focus := false

#S, 0, 1, 2, 3, 4, PI, 5, office
var position := "S"
var last_position := "S"

#info
var camara: int
var cam_activa: bool
var door_closed := false
var door_closed_log := false

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
	
	if AI_level == 0 or position == "office": # si ya estña en la oficina, no se va a mover...
		return
	
	if door_closed:
		door_closed_log = true
	else:
		if door_closed_log == true: # resetea los ticks
			@warning_ignore("integer_division")
			tick_count = 0 + (AI_level / 2) # en niveles altos te deja 1 segundo
			door_closed_log = false
	
	if gotcha > 0:
		if position == "PI":
			if door_soft_focus == true or (camara == 11 and cam_activa) or door_closed:
				gotcha = 0
				print_rich("[color=cyan]GOTCHA!")
		else:
			gotcha = 0
	
	var tick_count_limit: int
	
	if Global.debug["cheats"]["ultra_agresive"]:
		tick_count_limit = 1
	elif position != "PI":
		tick_count_limit = 40
	else:
		tick_count_limit = 15
	
	tick_count += 1
	if tick_count == tick_count_limit:
		tick_count = 0
		movement_oportunity(Global.noche, AI_level)

func movement_oportunity(_noche: int, AI: int):
	
	var movement_hit := false
	var ipos = str_to_var(position)
	if ipos == null:
		ipos = 99999
	var rand_MO
	
	
	if position != "PI":
		door_fail_count = 0
		if door_soft_focus and ipos == 5: # 5 siempre va a la puerta. Así evito que se teletransporte
			movement_hit = false
		else:
			rand_MO = randi_range(0, 20) # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
			if AI > rand_MO:
				movement_hit = true
	
	elif not door_closed:
		rand_MO = randi_range(0, 20) # siempre acierta en nivel 20
		if AI > rand_MO:
			movement_hit = true
		else:
			if door_fail_count < 0:
				door_fail_count = 0
			door_fail_count += 1
		if door_fail_count == 5: # tope de fallos en la puerta. Que salte justo cuando d_f_c = 5 y no en el siguiente MO es intencional
			movement_hit = true
	
	else:
		rand_MO = randi_range(0, 50) # AI = 1: 22%, AI = 20: 80% (de que no se valla). Todo lo demas lineal entre esas 2
		if AI * 1.5 + 10 <= rand_MO:
			movement_hit = true
		else:
			if door_fail_count > 0:
				door_fail_count = 0
			door_fail_count -= 1
		if door_fail_count == -11: # tope de fallos en la puerta. Que salte justo cuando d_f_c = 5 y no en el siguiente MO es intencional
			movement_hit = true
	
	
	if lock_movement == true:
		if position == "PI": # comprueva que acaba de llegar a la puerta. Si lo paras, si que se vuelve
			if not door_closed:
				movement_hit = false
				if gotcha > 0:
					gotcha -= 1
				else:
					lock_movement = false
			else:
				lock_movement = false
	
	
	if movement_hit:
		move(ipos, AI)
	else:
		print_rich("[color=cyan]Bonnie movement no: from ", position)
	

func move(ipos, AI):
	
	last_position = position # poniendolo aqui en vez de al final consigo que se mantenga fiel mientras no se mueve
	
	if position == "S":
		position = "1"
	elif ipos < 4:
		position = str(ipos + 1)
	
	elif ipos == 4:
		var rand_go = randi_range(0, 20) # probabilildad de pasar por cam 8 si AIes baja
		if AI > rand_go and not door_soft_focus:
			position = "PI"
		else:
			position = "5"
	
	elif ipos == 5:
		position = "PI"
	
	elif position == "PI":
		if door_closed:
			var rand_go = randi_range(0, 20) # nunca pasa con IA < 11
			if AI > rand_go + 18:
				position = "5"
			elif AI > rand_go + 15:
				position = "3"
			elif AI > rand_go + 11:
				position = "2"
			elif AI > rand_go + 5:
				position = "1"
			else:
				position = "0"
		else:
			position = "office"
	
	if position == "PI":
		gotcha = 1 # bloquea 1 extra hasta que le miras...
		lock_movement = true # bloquea el primer intento siempre
		
	print_rich("[color=cyan]Bonnie movement yes: from ", last_position, " to ", position)
	emit_signal("movement", position, last_position)

#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Esc"):
		#var ipos = str_to_var(position)
		#if ipos == null:
			#ipos = 99999
		#move(ipos, AI_level)
