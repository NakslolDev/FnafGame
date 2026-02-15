extends Node

#Constants (or other things). You can tweek these
const GENERAL_TICK_LIMIT := 25 # la cantidad de ticks para un oportunity movement
const DOOR_TICK_LIMIT := 15
const UA_TICK_LIMIT := 1
const OPENING_SAFE_TICK_LIMIT := 5 * 20 # 20 segundos

const MAXIMUM_FAILS_WHEN_DOOR_OPEN := 4
const MAXIMUM_FAILS_WHEN_DOOR_CLOSED := 4

const AI_LIMIT_FOR_EXTRA_BLOCKS_WHEN_NOT_SEEN := 10 # cuando está en la puerta, pero no le has visto, bloquea su movimiento más veces...
const EXTRA_BLOCKS_WHEN_NOT_SEEN_UNDER_LIMIT := 2
const EXTRA_BLOCKS_WHEN_NOT_SEEN_OVER_LIMIT := 1

#Constants. You canNOT tweek these
const RIGHT_DOOR_CAM := 13

#AI variables
var AI_level: int # Indica el nivel. No necesita reset, pues se asigna en global automaticamente.
var tick_count := 0 # cuenta los ticks que han pasado. Si llega a tick count limit (se decide en la propia funcion tick dependiendo de la situación), se vuelve 0 e intetará moverse
var gotcha := 0 # gotcha indica si le has visto cuando está en la puerta. Asi puedo hacer que tarde un poco más antes de que te entre si no te has enterado.
				# En concreto, el numero indica la cantidad de veces que fallará. Si le miras de cualquier forma, se vuelve 0.
				# En el caso de bonnie, se vuelve 1 al llegar a la puerta.
var gotcha_lights := false # indica si la has visto con la linterna especificamente.
var lock_movement := false # Se vuelve true cuando llega a la puerta, y bloquea una vez su intento de movimiento. Está por debajo de gotcha.
var door_fail_count := 0 	# Cuenta la cantidad de veces que no se ha movido. Está por debajo de lock movement.
							# en el caso de chica, le da igual si tienes la puerta abierta o cerrada, se moverá igual (excepto a donde)

#S, 1, 2, 3, 4, 5, 6, PD, Office
var position = "S"
var last_position = "S"

#info
var door_closed := false # Si la puerta está cerrada
var door_closed_log := false 	# Es una variable auxiliar. Como door_closed se actualiza en tiempo real, la necesito para mantener esa información.
								# Su principal funcion es ayudar a que si abres
var camara: int # En qué camara estás. Sirve para gotcha
var cam_activa: bool # Si tienes las camaras activadas. Sirbe también para gotcha
var watching_cam_6_when_i_am_there_and_door_is_open_and_i_am_attempting_to_open_the_safe := false # Se explica sola (I is chica)
var door_soft_focus := false 	# Controla si estás iluminando su puerta con la linterna. En ese caso, no entrará. También sirve para gotcha.


signal movement(to: int, from: int) # La señal de movimiento. 

func reset(): # Resetea las variables al principio de la noche
	tick_count = 0
	gotcha = 0
	lock_movement = false
	door_fail_count = 0
	position = "S"
	last_position = "S"
	door_closed = false
	door_soft_focus = false

func tick(): # Esta funcion se llama cada tick, 5 veces por segundo
	
	if AI_level == 0  or position == "office":  # Si está desactivado o si ya está en la oficina, no se va a mover...
		return
	
	if position == "PD":
		if door_closed:
			door_closed_log = true # Guarda la información
		elif door_closed_log == true: # Solo se activa el primer tick después de que abrir la puerta.
			@warning_ignore("integer_division")
			if tick_count > 0 + (AI_level / 2): # Si está a punto de moverse, te deja un poco más de tiempo.
				@warning_ignore("integer_division")
				tick_count = 0 + (AI_level / 2) # en niveles altos te deja 1 segundo
			door_closed_log = false
	
	
	if position == "PD": # Gotcha > 0 significa que todavía no le has visto y que sigue bloqueando por ello.
		if gotcha > 0:
			if door_soft_focus or (camara == RIGHT_DOOR_CAM and cam_activa) or door_closed: # Si le estás mirando con la linterna o por las camaras o tienes la puerta cerrada, le has "mirado".
				gotcha = 0
				print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]GOTCHA!")
		if door_soft_focus: # Comprueva si le has mirado con la linterna
			gotcha_lights = true
	else:
		gotcha_lights = false
		gotcha = 0
	
	var tick_count_limit: int # Declara el límite al que tiene que llegar tick count limit antes de moverse
	
	if Global.debug["cheats"]["ultra_agresive"]: # se intenta mover cada tick con el hack ultra agresive
		tick_count_limit = UA_TICK_LIMIT
	elif position != "PD": # Si no está en las puertas
		if (Global.noche == 5 and Global.mapa["door_office_open"] and not Global.mapa["safe_open"]) and position == "6": # Está intentando abrir la caja fuerta. la condicion es un poco larga, pero asi es más organico. Reacciona al mapa y no a una varable
			tick_count_limit = OPENING_SAFE_TICK_LIMIT # 20 segundos
			print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]WAITING: ", tick_count, " of ", tick_count_limit)
		else: # noramlmente
			tick_count_limit = GENERAL_TICK_LIMIT # 25 ticks, cada 5 segundos
	else: # En la puerta, 3 segundos
		tick_count_limit = DOOR_TICK_LIMIT
	
	tick_count += 1
	
	if tick_count < tick_count_limit:
		return
	
	if watching_cam_6_when_i_am_there_and_door_is_open_and_i_am_attempting_to_open_the_safe:
		print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]still hearing, be pacient")
		return # no dejo que se mueva si estás en esa camara mientras intenta abrir
	
	tick_count = 0 # resetea el contador
	movement_oportunity() # e intenta moverse


func movement_oportunity(always_do := false): # always_do hace que se mueva sin importar el nivel de IA. Lo uso, por ejemplo, cuando termina de abrir la caja.
	
	if gotcha > 0: # Si no lo has mirado
		gotcha -= 1 # Resta 1 al contador
		print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]Chica movement no (still not seen): from ", position)
		return
	
	if lock_movement and position == "PD": # comprueva que acaba de llegar a la puerta. Si lo paras, si que se vuelve
		lock_movement = false
		if not door_closed: # puerta abierta. Si la puerta está cerrada, si que intentará moverse. Esto es en pos del jugador, para que se largue antes
			print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]Chica movement no (locked first try): from ", position)
			return
	
	if position != "PD":
		door_fail_count = 0
		if AI_level > randi_range(0, 20) or always_do: # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
			move()
			return
	
	elif not door_closed:
		if AI_level >= randi_range(0, 20): # Siempre acierta a nivel 20
			move()
			return
		else:
			door_fail_count += 1
		if door_fail_count == MAXIMUM_FAILS_WHEN_DOOR_OPEN: # tope de fallos en la puerta. Que salte justo cuando door_fail_count = 5 y no en el siguiente MO es intencional
			move()
			return
	else:
		if randi_range(0, 20 + AI_level) < 30: # en niveles bajos salga más rapido aun. Casi siempre. En altos ~75%
			move()
			return
		else:
			door_fail_count += 1
		if door_fail_count == MAXIMUM_FAILS_WHEN_DOOR_CLOSED: # tope de fallos en la puerta. Que salte justo cuando door_fail_count = 5 y no en el siguiente MO es intencional
			move()
			return
	
	# en este caso, door_fail_count funciona en paralelo tanto si tienes la puerta abierta como cerrada...
	
	print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]Chica movement no: from ", position) # si llega hasta aquí es que no ha conseguido moverse
	

func move():
	
	# Para dejar clara la diferencia entre position, last position y true last, un ejemplo. Ha salido del escenario y está en 1:
	# Normalmente: 									position = 1, last position = S
	# Justo antes de moverse, cuando entra en move: position = 1, last position = 1, true last = S
	# Despues de moverse: 							position = 2, last position = 1
	
	var true_last = last_position 
	last_position = position
	var repetir := true
	
	while repetir: # para que sea menos probable que vuelva a la misma casilla de donde vino, pero no imposible
		
		position = last_position # vuelves a poner la posicion inicial, si no avanzaría varias veces
		
		if position == "S": # Escenario -> 1 -> 2 -> 3. Fácil
			position = "1"
		elif position == "1":
			position = "2"
		elif position == "2":
			position = "3"
		
		elif position == "3": # De la 3 puede ir a la cam 2, 3 o a la 6.
			if AI_level + 40 < randi_range(0, 60): # ~30 % de ir a la 2 con AI = 1, 0% con AI = 20
				position = "2"
			else:
				if randi_range(0, 1) == 0: # 50-50 de ir a la 4 o a la 6
					position = "4"
				else:
					position = "6"
		
		elif position == "4": # De la 4 puede ir a muchos sitios...
			var rand_go = randi_range(0, 200 + AI_level) # Más o menos un 25% todas, excepto irse a la puerta, que será más probable cuanto más nivel
			if rand_go > 150:
				if door_soft_focus: # intentará ir a la puerta. De no poder, por que está la linterna enfocando, se irá a 6
					position = "6"
				else:
					position = "PD"
			elif rand_go > 100:
				position = "5" # irse a pas
			elif rand_go > 50:
				position = "6" # irse a 6
			else:
				position = "3" # volver a 3
		
		elif position == "5": # 5 es parts and services, por lo que solo puede volver a 4...
			position = "4"
		
		elif position == "6":
			var rand_go = randi_range(1, 150 + AI_level)
			if rand_go > 100: # intenta ir a la puerta
				if door_soft_focus:
					position = "4" # de no poder, se va a la pos 4
				else:
					position = "PD"
			elif rand_go > 50:
				position = "4"
			else:
				position = "3"
		
		elif position == "PD": # desde 50% hasta 25% de que no entre si las luces están apagadas y no le has iluminado con la linterna
			if door_closed or (not Global.energia["Luces"] and not gotcha_lights and randi_range(0, 20 + AI_level) < 10):
				if true_last == "4": # nunca volverá a la misma. simplemente pasará de largo
					position = "6"
				else:
					position = "4"
			else:
				position = "office"
		
		if true_last == position:
			if position != "PD":
				if randi_range(0, 20 + AI_level) < 10: # desde 50-50 a 25-75 de no volver a la misma posición, para que a AI = 20 no repita tanto
					repetir = false
			else:
				if randi_range(0, 20 + AI_level) > 10: # desde 50-50 a 75-25 de no volver a la misma posición, para que a AI = 20 repita más (si va a la puerta)
					repetir = false
		else: # si no vuelve a la posicion anterior, no repetir
			repetir = false
	
	if position == "PD": # Cuando llega a PD. Como no se puede quedar quieta (en esta función) no hay problemas
		if AI_level < AI_LIMIT_FOR_EXTRA_BLOCKS_WHEN_NOT_SEEN:
			gotcha = EXTRA_BLOCKS_WHEN_NOT_SEEN_UNDER_LIMIT # bloquea 2 extra hasta que le miras...
		else:
			gotcha = EXTRA_BLOCKS_WHEN_NOT_SEEN_OVER_LIMIT # bloquea 1 extra hasta que le miras...
		lock_movement = true # bloquea el primer intento siempre
	
	print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (chica) - ", "[color=yellow]Chica movement yes: from ", last_position, " to ", position)
	emit_signal("movement", position, last_position) # Envía la señal de que se ha movido
