extends Node

#Constants (or other things). You can tweek these
const GENERAL_TICK_LIMIT := 40 # la cantidad de ticks para un oportunity movement
const DOOR_TICK_LIMIT := 20
const UA_TICK_LIMIT := 1

const MAXIMUM_FAILS_WHEN_DOOR_OPEN := 3
const MAXIMUM_FAILS_WHEN_DOOR_CLOSED := 8

const AI_LIMIT_FOR_EXTRA_BLOCKS_WHEN_NOT_SEEN := 10 # cuando está en la puerta, pero no le has visto, bloquea su movimiento más veces...
const EXTRA_BLOCKS_WHEN_NOT_SEEN_UNDER_LIMIT := 2
const EXTRA_BLOCKS_WHEN_NOT_SEEN_OVER_LIMIT := 1

#Constants. You canNOT tweek these
const LEFT_DOOR_CAM := 11


#AI variables
var AI_level: int # Indica el nivel. No necesita reset, pues se asigna en global automaticamente.
var tick_count := 0 # cuenta los ticks que han pasado. Si llega a tick count limit (se decide en la propia funcion tick dependiendo de la situación), se vuelve 0 e intetará moverse
var gotcha := 0 # gotcha indica si le has visto cuando está en la puerta. Asi puedo hacer que tarde un poco más antes de que te entre si no te has enterado.
				# En concreto, el numero indica la cantidad de veces que fallará. Si le miras de cualquier forma, se vuelve 0.
				# En el caso de bonnie, se vuelve 1 al llegar a la puerta.
var lock_movement := false # Se vuelve true cuando llega a la puerta, y bloquea una vez su intento de movimiento. Está por debajo de gotcha.
var door_fail_count := 0 	# Cuenta la cantidad de veces que no se ha movido. Está por debajo de lock movement.
							# uso el positivo para intentos de entrar y el negativo para intentos de irse.

#S, 0, 1, 2, 3, 4, PI, 5, office
var position := "S"
var last_position := "S"

#info -> información del jugador. Cosas generales
var camara: int # En qué camara estás. Sirve para gotcha
var cam_activa: bool # Si tienes las camaras activadas. Sirbe también para gotcha
var door_closed := false # Si la puerta está cerrada
var door_closed_log := false 	# Es una variable auxiliar. Como door_closed se actualiza en tiempo real, la necesito para mantener esa información.
								# Su principal funcion es ayudar a que si abres
var door_soft_focus := false 	# Controla si estás iluminando su puerta con la linterna. En ese caso, no entrará. También sirve para gotcha.

signal movement(to: int, from: int) # La señal de movimiento. 

func reset(): # Reseta todas las variables al inicio de la noche.
	tick_count = 0
	gotcha = 0
	lock_movement = false
	door_fail_count = 0
	position = "S"
	last_position = "S"
	door_closed = false
	door_soft_focus = false

func tick(): # Esta función se llama cada tick. Por defecto, son 5 veces cada segundo
	
	if AI_level == 0 or position == "office": # Si está desactivado o si ya está en la oficina, no se va a mover...
		return
	
	if position == "PI": # este tiempo extra solo devería ocurrir si ya está de por sí en la puerta
		if door_closed:
			door_closed_log = true # Guarda la información
		elif door_closed_log: # Solo se activa el primer tick después de que abrir la puerta.
			@warning_ignore("integer_division")
			if tick_count > (AI_level / 2): # Si está a punto de moverse, te deja un poco más de tiempo.
				@warning_ignore("integer_division")
				tick_count = (AI_level / 2) # en niveles altos te deja 1 segundo
			door_closed_log = false
	
	if gotcha > 0: # Gotcha > 0 significa que todavía no le has visto y que sigue bloqueando por ello.
		if position == "PI":
			if door_soft_focus or (camara == LEFT_DOOR_CAM and cam_activa) or door_closed: # Si le estás mirando con la linterna o por las camaras o tienes la puerta cerrada, le has "mirado".
				gotcha = 0
				print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]GOTCHA!")
		else: # Gotcha solo devería ser != 0 en la puerta
			gotcha = 0
	
	var tick_count_limit: int # Declara el límite al que tiene que llegar tick count limit antes de moverse
	
	if Global.debug["cheats"]["ultra_agresive"]: # se intenta mover cada tick con el hack ultra agresive
		tick_count_limit = UA_TICK_LIMIT
	elif position != "PI": # si no está en la puerta, se intenta mover cada 40 ticks = 8 segundos
		tick_count_limit = GENERAL_TICK_LIMIT
	else: # si está en la puerta, intentará moverse cada 15 ticks = 3 segundos
		tick_count_limit = DOOR_TICK_LIMIT
	
	tick_count += 1 # cada tick añade uno a tick count
	
	if tick_count >= tick_count_limit: # Si llega o supera el límite
		tick_count = 0 # resetea el contador
		movement_oportunity() # Y se intenta mover


func movement_oportunity(): # Decide si se va a mover. Por regla general, cuanto más nivel de IA, más posibilidades de moverse
	
	
	if gotcha > 0: # Si no lo has mirado
		gotcha -= 1 # Resta 1 al contador
		print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement no (still not seen): from ", position)
		return
	
	if lock_movement and position == "PI": # comprueva que acaba de llegar a la puerta. Si lo paras, si que se vuelve
		lock_movement = false
		if not door_closed: # puerta abierta. Si la puerta está cerrada, si que intentará moverse. Esto es en pos del jugador, para que se valla antes
			print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement no (locked first try): from ", position)
			return
	
	
	if position != "PI": # Si no está en la puerta
		if (door_soft_focus and position == "5"): # 5 siempre va a la puerta. Así evito que aparezca de la nada si tienes la linterna apuntando a la puerta
			print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement no (flashlight on door): from ", position)
			return
		if AI_level > randi_range(0, 20): # es intencionalmente 21 posibles, para que siempre quepa la posibilidad de que falle
			move()
			return
	
	elif not door_closed: # puerta abierta
		if AI_level >= randi_range(0, 20): # siempre acierta en nivel 20
			move()
			return
		
		if door_fail_count < 0: # Si no se mueve, comprueva los fallos.
			door_fail_count = 0 # Primero resetea a 0 en caso de que fuese negativo.
		door_fail_count += 1 # Añade un intento fallido de entrar 
		if door_fail_count == MAXIMUM_FAILS_WHEN_DOOR_OPEN: # tope de fallos en la puerta. Que salte justo cuando door_fail_count = 4 y no en el siguiente MO es intencional
			move()
			return
	
	else: # puerta cerrada
		if 50 + AI_level * 2 <= randi_range(0, 100): # AI = 1:~ 50%, AI = 20:~ 90% (de que se quede en la puerta).
			move()
			return
		
		if door_fail_count > 0: # Si no se mueve, comprueva los fallos.
			door_fail_count = 0 # Primero resetea a 0 en caso de que fuese positivo.
		door_fail_count -= 1 # Añade un intento fallido de irse 
		if door_fail_count == -MAXIMUM_FAILS_WHEN_DOOR_CLOSED: # tope de fallos en la puerta. Que salte justo cuando door_fail_count = -10 y no en el siguiente MO sigue siendo intencional
			move()
			return
	
	# Ahora mismo, si abres la puerta, e intenta entrar, pero no lo hace, y vuelves a cerrar, el contador se resetea. De momento lo dejo intencional
	
	print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement no: from ", position) # si llega hasta aquí es que no ha conseguido moverse


func move(): # decide a donde moverse
	
	var ipos = int(position) # la posicion es un string, ya que puede ser S (escenario), PI (puerta izquierda) o office (oficina), por lo que la transformo en un numero a otra variable para poder comparar numericamente
	last_position = position # poniendolo aqui en vez de al final consigo que se mantenga fiel mientras no se mueve
	
	if position == "S": # si está en el escenario
		position = "1"
	elif position.is_valid_int() and ipos < 4: # si la posicion es un numero, y este es menor que 4, avanca 1 casilla.
		position = str(ipos + 1)
	
	elif position == "4":
		if AI_level > randi_range(0, 20) and not door_soft_focus: # Si la IA es baja o estás mirando a la puerta, se irá al armario. Si no, irá directamente a la puerta
			position = "PI"
		else:
			position = "5"
	
	elif position == "5": # Del armario va directamente a la puerta
		position = "PI"
	
	elif position == "PI": # De la puerta decide a donde irse
		door_fail_count = 0 # Resetea el contador de los fallos de la puerta.
		if door_closed:
			var rand_go = randi_range(0, 20)
			if AI_level > rand_go + 18: # si eres un desgraciado, de la puerta se irá al armario
				position = "5"
			elif AI_level > rand_go + 15: # Puede irse a las 3 primeras posiciones. Cuanto más adelantado, menos probable e incluso imposible si tiene el nivel de IA muy bajo
				position = "3"
			elif AI_level > rand_go + 11:
				position = "2"
			elif AI_level > rand_go + 5:
				position = "1"
			else: # Position 0 es el baño. Es igual que el escenario, pero en otra camara.
				position = "0"
		else:
			position = "office" # si la puerta no está cerrada, evidentemente entra
	
	if position == "PI": # Cuando llega a PI. Como no se puede quedar quieto (en esta función) no hay problemas
		if AI_level < AI_LIMIT_FOR_EXTRA_BLOCKS_WHEN_NOT_SEEN:
			gotcha = EXTRA_BLOCKS_WHEN_NOT_SEEN_UNDER_LIMIT # bloquea 2 extra hasta que le miras...
		else:
			gotcha = EXTRA_BLOCKS_WHEN_NOT_SEEN_OVER_LIMIT # bloquea 1 extra hasta que le miras...
		lock_movement = true # bloquea el primer intento siempre
	
	if position != last_position:
		print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement yes: from ", last_position, " to ", position)
		movement.emit(position, last_position) # Envía la señal de que se ha movido
	else:
		print_rich(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - (bonnie) - ", "[color=cyan]Bonnie movement hitted but stayed still: from ", position)
