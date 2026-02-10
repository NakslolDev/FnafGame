extends Node

var AI_level: int # No voy a volver a comentar lo que ya he comentado en bonnie y en chica...
var tick_count := 0
var tick_focus_count := 0
var animacion_go_back := false
var gotcha := 0
var lock_movement := false
var next_room: String # esta variable determina a que habitacion intentará ir
var door_fail_count := 0
var flashlight_stunt := 0

#63 posiciones posibles... (segun chat gpt)
#map -> positions per room (0 = s, so I can int)
#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall, office
# Duc1, Duc2, Duc3... Duc8
# position 0 -> Especiales, dependiendo de room (atacando o estado inicial o office)
var room := "pas"
var position := 0
var last_room := "pas"
var last_position := 0
var true_last_room := "pas"

signal movement(to_pos: String, to_room: int, from_pos: String, from_room: int)
signal move_back()

#info
var soft_focus_I := false
var soft_focus_D := false
var hard_focus_I := false
var hard_focus_D := false
var soft_focus_DF := false
var soft_focus_DB := false
var hard_focus_DF := false
var hard_focus_DB := false
var door_I_closed := false
var door_I_closed_log := false
var door_D_closed := false
var door_D_closed_log := false

var duct_heater := { # el valor real de los ductos
	"1": false,
	"2": false,
	"3": false,
	"4": false,
	"5": false,
	"6": false,
	"7": false,
	"8": false,
}

var duct_heater_memory := { # lo que utiliza foxy para decidir
	"1":  {"on": false, "time": 0},
	"2":  {"on": false, "time": 0},
	"3":  {"on": false, "time": 0},
	"4":  {"on": false, "time": 0},
	"5":  {"on": false, "time": 0},
	"6":  {"on": false, "time": 0},
	"7":  {"on": false, "time": 0},
	"8":  {"on": false, "time": 0},
}

func _ready():
	Bonnie.connect("movement", Callable(self, "movement_bonnie"))
	Chica.connect("movement", Callable(self, "movement_chica"))
	Global.connect("Energy_Breakdown", Callable(self, "energy_breakdown"))

func reset():
	
	duct_heater = {
		"1": false,
		"2": false,
		"3": false,
		"4": false,
		"5": false,
		"6": false,
		"7": false,
		"8": false,
	}
	
	duct_heater_memory = {
		"1":  {"on": false, "time": 0},
		"2":  {"on": false, "time": 0},
		"3":  {"on": false, "time": 0},
		"4":  {"on": false, "time": 0},
		"5":  {"on": false, "time": 0},
		"6":  {"on": false, "time": 0},
		"7":  {"on": false, "time": 0},
		"8":  {"on": false, "time": 0},
	}
	
	tick_count = 0
	tick_focus_count = 0
	animacion_go_back = false
	lock_movement = false
	next_room = "0"
	#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall, office
	room = "pas"
	position = 0
	last_room = "pas"
	last_position = 0
	door_fail_count = 0
	
	# info (a parte de los heaters)
	soft_focus_I = false
	soft_focus_D = false
	hard_focus_I = false
	hard_focus_D = false
	soft_focus_DF = false
	soft_focus_DB = false
	hard_focus_DF = false
	hard_focus_DB = false
	door_I_closed = false
	door_I_closed_log = false
	door_D_closed = false
	door_D_closed_log = false


func tick(): # Cada tick (5 veces por segundo)
	
	if AI_level == 0 or room == "office": # si ya estña en la oficina, no se va a mover...
		return
	
	if room == "lhall" and position == 0: # este tiempo extra solo devería ocurrir si ya está de por sí en la puerta
		if door_I_closed:
			door_I_closed_log = true # Guarda la información
		elif door_I_closed_log: # Solo se activa el primer tick después de que abrir la puerta.
			@warning_ignore("integer_division")
			if tick_count > 0 + (AI_level / 2): # Si está a punto de moverse, te deja un poco más de tiempo.
				@warning_ignore("integer_division")
				tick_count = 0 + (AI_level / 2) # en niveles altos te deja 1 segundo
			door_I_closed_log = false
	
	if room == "lhall" and position == 0: # este tiempo extra solo devería ocurrir si ya está de por sí en la puerta
		if door_D_closed:
			door_D_closed_log = true # Guarda la información
		elif door_D_closed_log: # Solo se activa el primer tick después de que abrir la puerta.
			@warning_ignore("integer_division")
			if tick_count > 0 + (AI_level / 2): # Si está a punto de moverse, te deja un poco más de tiempo.
				@warning_ignore("integer_division")
				tick_count = 0 + (AI_level / 2) # en niveles altos te deja 1 segundo
			door_D_closed_log = false
	
	if gotcha > 0: # Gotcha > 0 significa que todavía no le has visto y que sigue bloqueando por ello.
		if room == "lhall" and position == 0:
			if soft_focus_I or door_I_closed: # Si le estás mirando con la linterna (por las camaras no se ve...) o tienes la puerta cerrada, le has "mirado".
				gotcha = 0
				print_rich("[color=B5623F]GOTCHA!")
		elif room == "rhall" and position == 0:
			if soft_focus_D or door_D_closed:
				gotcha = 0
				print_rich("[color=B5623F]GOTCHA!")
		else: # Gotcha solo devería ser != 0 en la puerta
			gotcha = 0
	elif gotcha < 0:
		gotcha = 0	
	
	var tick_count_limit: int # Declara el límite al que tiene que llegar tick count limit antes de moverse
	
	if position == 0 and (room.begins_with("Duc") or room.ends_with("hall")):
		if (room == "rhall" and hard_focus_D) or (room == "lhall" and hard_focus_I) or (room == "Duc8" and hard_focus_DB) or (room == "Duc5" and hard_focus_DF):
			tick_count = 0
			tick_focus_count += 1
			print_rich("[color=B5623F]Foxy stalled")
		else:
			tick_focus_count = 0
		tick_count_limit = 20
	elif room.begins_with("Duc") and duct_heater[room.substr(3)]: # no uso duct_heater_memory porque no se actualiza lo suficientemente rápido.
		tick_count_limit = 5 # esto hace que si le das con el heater a foxy siempre salga rapido
		tick_focus_count = 0
		flashlight_stunt = 0 # no se queda quieto si activas el heater
	elif room.begins_with("Duc"):
		tick_count_limit = 25 - AI_level # foxy se mueve más rapido cuanta + AI, pues en los ductos siempre acierta el movimiento
		tick_focus_count = 0
	else:
		tick_count_limit = 25
		tick_focus_count = 0
	
	if Global.debug["cheats"]["ultra_agresive"] and not room.begins_with("Duc"):
		tick_count_limit = 1 # no tengo ni idea de como reemplazarlo sin que se rompa, asi que lo cambio aqui
	
	@warning_ignore("integer_division") # evita que me salte el aviso
	if tick_focus_count >= 10 + (AI_level / 2) and animacion_go_back == false:
		emit_signal("move_back")
		animacion_go_back = true
	
	tick_count += 1
	
	if tick_count >= tick_count_limit:
		tick_count = 0
		movement_oportunity()


func movement_oportunity():
	
	if flashlight_stunt > 0: # no se puede mover por tres movimientos después de hecharlo hacia atras con la linterna
		flashlight_stunt -= 1
		return
	
	var movement_hit := false
	var rand_MO
	
	if room.begins_with("Duc"):
		movement_hit = true
	else:
		rand_MO = randi_range(0, 20)
		if AI_level > rand_MO:
			movement_hit = true
		
		if room.ends_with("hall") and position == 0:
			door_fail_count += 1
			if room == "rhall" and door_D_closed and door_fail_count >= 3:
				movement_hit = true
			elif room == "rhall" and not door_D_closed and door_fail_count >= 6:
				movement_hit = true
			elif room == "lhall" and door_I_closed and door_fail_count >= 3:
				movement_hit = true
			elif room == "lhall" and not door_I_closed and door_fail_count >= 6:
				movement_hit = true
		else:
			door_fail_count = 0
	
	if lock_movement == true:
		if position == 0 and (room.begins_with("Duc") or room.ends_with("hall")): # comprueva que acaba de llegar a las entradas de la oficina. Si lo paras, si que se vuelve
			if (room == "lhall" and not door_I_closed) or (room == "rhall" and not door_D_closed) or room.begins_with("Duc"):
				movement_hit = false
				if gotcha > 0:
					gotcha -= 1
				else:
					lock_movement = false
			else:
				lock_movement = false
	
	if movement_hit:
		move()
	else:
		print_rich("[color=FA8150]Foxy movement no: from ", position, " in ", room)


# skip decision lo utilizo cuando bonnie o chica lo expulsan, pues en esa funcion uso otro decide que obliga a no ir a las puertas
func move(skip_decision := false): # esta funcion va a ser increiblemente larga... Voy a separarla en otras funciones dependiendo de la habitacion
	
	var soft_focus := false
	last_position = position
	last_room = room
	
	if not skip_decision:
		decide_next_room(true) # el true es de check, que es para que solo cambie si cambia la memoria de ducts
	
	if next_room == "office" and ((room == "rhall" and position != 0 and soft_focus_D) or (room == "lhall" and position != 0 and soft_focus_I) or (room == "Duc8" and position == 4 and soft_focus_DB) or (room == "Duc5" and position == 3 and soft_focus_DF)):
		soft_focus = true
	else:
		call("move_" + room)
	
	if (room == "rhall" or room == "lhall") and position == 0:
		gotcha = 2
	
	if soft_focus:
		print_rich("[color=FA8150]Foxy soft focus: from ", position, " in ", room)
		return
	
	print_rich("[color=FA8150]Foxy movement: to ", position, " in ", room, " from ", last_position, " in ", last_room)
	emit_signal("movement", position, room, last_position, last_room)
	if room != last_room and not room == "office": # si cambia de habitacion y no es a office, que en office no hay funcion
		true_last_room = last_room
		decide_next_room()

func move_back_to():
	
	last_position = position
	last_room = room
	
	if room == "Duc5":
		if randi_range(0, 1) == 0:
			position = 2
		else:
			position = 4
		flashlight_stunt = 3
	elif room == "Duc8":
		if randi_range(0, 1) == 0:
			position = 3
		else:
			position = 5
		flashlight_stunt = 3
	elif room == "lhall" or room == "rhall":
		position = 2
		next_room = "0" # para que recalcule
	
	print_rich("[color=FA8150]Foxy found my flashlight : from ", position, " in ", room)
	emit_signal("movement", position, room, last_position, last_room)
	
	animacion_go_back = false
	tick_focus_count = 0
	@warning_ignore("integer_division")
	tick_count = -15 + (AI_level / 2)  # stalea 3-1 segundos

func movement_bonnie(to, _a = null):
	if room == "lhall" and position == 0 and to == "PI":
		decide_lhall(false, true)
		move(true)

func movement_chica(to, _a = null):
	if room == "rhall" and position == 0 and to == "PD":
		decide_rhall(false, true)
		move(true)

func energy_breakdown():
	
	if AI_level == 0:
		return
	
	print("[color=FA8150]ME LLAMARON?????")
	
	var change := false
	
	for key in duct_heater_memory.keys():
		if duct_heater_memory[key]["on"] != duct_heater[key]:
			duct_heater_memory[key]["on"] = duct_heater[key]
			duct_heater_memory[key]["time"] = 0
			change = true
	
	if change:
		decide_next_room()


# check es: solo cambia de decisión si ves un ducto que ha cambiado
func decide_next_room(check: bool = false): # si no hay un dead end, no puede volver a la habitacion anterior
	
	var duct_act := false
	var dead_end := false
	
	print_rich("[color=B5623F]Foxy will think... just check: ", check)
	
	duct_act = check_ducts()
	
	if not check: _advance_time_on_ducts_memory()
	
	if (room == "lhall" and position == 0) or (room == "rhall" and position == 0): # es necesario que haga un checkeo antes de intentar entrar para ver si las puertas estan cerradas o abiertas
		duct_act = true
	
	if next_room.begins_with("Duc") and duct_heater_memory[next_room.substr(3)]["on"]:
		dead_end = true
		print_rich("[color=cb5a29]Foxy found a dead end: from ", position, " in ", room)
	
	if (check and duct_act) or not check or next_room == "0":
		call("decide_" + room, dead_end)
		print_rich("[color=cb5a29]Foxy will go to ", next_room, " knowing last room was ", true_last_room)
		print_rich("[color=B5623F]--- Estado de duct_heater_memory ---")
		for key in duct_heater_memory.keys():
			var data = duct_heater_memory[key]
			var estado = str(data["on"])
			var tiempo = str(data["time"])
			print_rich("[color=B5623F]Ducto " + key + " → on: " + estado + ", time: " + tiempo + "[/color]")

func check_ducts() -> bool:
	
	var duct_act: bool = false
	
	if (room == "main" and position == 1) or (room == "arcade" and position == 1) or room == "Duc1":
		duct_heater_memory["1"]["time"] = 0 # como esto solo comprueva el tiempo que ha pasado desde que sabe que está activo, puedo resetearlo siempre
		if duct_heater_memory["1"]["on"] != duct_heater["1"]:
			duct_heater_memory["1"]["on"] = duct_heater["1"]
			duct_act = true
	if (room == "arcade" and position == 1) or (room == "arcade" and position == 2) or (room == "arcade" and position == 4) or room == "Duc2":
		duct_heater_memory["2"]["time"] = 0
		if duct_heater_memory["2"]["on"] != duct_heater["2"]:
			duct_heater_memory["2"]["on"] = duct_heater["2"]
			duct_act = true
	if (room == "main" and position == 2) or (room == "arcade" and position == 3) or (room == "pas" and position == 3) or room == "Duc3":
		duct_heater_memory["3"]["time"] = 0
		if duct_heater_memory["3"]["on"] != duct_heater["3"]:
			duct_heater_memory["3"]["on"] = duct_heater["3"]
			duct_act = true
	if (room == "main" and position == 4) or (room == "kitchen" and position == 1) or (room == "pas" and position == 2) or room == "Duc4":
		duct_heater_memory["4"]["time"] = 0
		if duct_heater_memory["4"]["on"] != duct_heater["4"]:
			duct_heater_memory["4"]["on"] = duct_heater["4"]
			duct_act = true
	if (room == "pas" and position == 1) or (room == "lhall" and position == 1) or (room == "rhall" and position == 1) or room == "Duc5":
		duct_heater_memory["5"]["time"] = 0
		if duct_heater_memory["5"]["on"] != duct_heater["5"]:
			duct_heater_memory["5"]["on"] = duct_heater["5"]
			duct_act = true
	if (room == "entrance" and position == 1) or (room == "kitchen" and position == 1) or (room == "almacen" and position == 1) or room == "Duc6":
		duct_heater_memory["6"]["time"] = 0
		if duct_heater_memory["6"]["on"] != duct_heater["6"]:
			duct_heater_memory["6"]["on"] = duct_heater["6"]
			duct_act = true
	if (room == "arcade" and position == 4) or (room == "closet" and position == 1) or room == "Duc7":
		duct_heater_memory["7"]["time"] = 0
		if duct_heater_memory["7"]["on"] != duct_heater["7"]:
			duct_heater_memory["7"]["on"] = duct_heater["7"]
			duct_act = true
	if (room == "closet" and position == 1) or (room == "lhall" and position == 2) or (room == "rhall" and position == 2) or (room == "almacen" and position == 2) or room == "Duc8":
		duct_heater_memory["8"]["time"] = 0
		if duct_heater_memory["8"]["on"] != duct_heater["8"]:
			duct_heater_memory["8"]["on"] = duct_heater["8"]
			duct_act = true
		
	print_rich("[color=B5623F]Did foxy learn something new?: ", duct_act)
	return duct_act

func _advance_time_on_ducts_memory():
	for i in range(1,9): # del 1 al 8
		if duct_heater_memory[str(i)]["on"]:
			duct_heater_memory[str(i)]["time"] += 1
		if duct_heater_memory[str(i)]["time"] == 3:
			duct_heater_memory[str(i)]["time"] = 0
			duct_heater_memory[str(i)]["on"] = false
			print_rich("[color=B5623F]Foxy forgot the duct ", i)

func decide_main(dead_end):
	
	if position == 1: # sigue un sistema de prioridad en el que va del mejor al peor. Este orden lo elijo yo, dependiendo de la distancia y el camino.
		if ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif ((true_last_room == "Duc1" and dead_end) or true_last_room != "Duc1") and not duct_heater_memory["1"]["on"]:
			next_room = "Duc1"
		elif ((true_last_room == "Duc4" and dead_end) or true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		else:
			next_room = "entrance"
	
	if position == 2:
		if ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif ((true_last_room == "Duc4" and dead_end) or true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		elif ((true_last_room == "Duc1" and dead_end) or true_last_room != "Duc1") and not duct_heater_memory["1"]["on"]:
			next_room = "Duc1"
		else:
			next_room = "entrance"
	
	if position == 3: # probablemente hay muchos casos que no se pueden llegar a dar, pero bueno...
		if true_last_room != "Duc3" and not duct_heater_memory["3"]["on"] and true_last_room != "Duc4" and not duct_heater_memory["4"]["on"]:
			var rand_go_to = randi_range(0, 1)
			if rand_go_to == 0:
				next_room = "Duc3"
			else:
				next_room = "Duc4"
		elif true_last_room != "Duc3" and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif true_last_room != "Duc4" and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		elif true_last_room != "Duc1" and not duct_heater_memory["1"]["on"]:
			next_room = "Duc1"
		else:
			next_room = "entrance"
	
	if position == 4:
		if ((true_last_room == "Duc4" and dead_end) or true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		elif ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif ((true_last_room == "entrance" and dead_end) or true_last_room != "entrance") and not duct_heater_memory["6"]["on"]:
			next_room = "entrance"
		else:
			next_room = "Duc1"
	
	if position == 5:
		if ((true_last_room == "Duc4" and dead_end) or true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		elif ((true_last_room == "entrance" and dead_end) or true_last_room != "entrance") and not duct_heater_memory["6"]["on"]:
			next_room = "entrance"
		elif ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		else:
			next_room = "Duc1"

func decide_arcade(dead_end):
	
	if position == 1 or position == 2: # el camino a escojer es el mismo
		if not duct_heater_memory["2"]["on"]:
			next_room = "Duc2"
		elif ((true_last_room == "Duc7" and dead_end) or true_last_room != "Duc7") and not duct_heater_memory["7"]["on"]:
			next_room = "Duc7"
		elif ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		else:
			next_room = "Duc1"
	
	if position == 3:
		if ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif ((true_last_room == "Duc7" and dead_end) or true_last_room != "Duc7") and not duct_heater_memory["7"]["on"]:
			next_room = "Duc7"
		else:
			next_room = "Duc1"
	
	if position == 4:
		if ((true_last_room == "Duc7" and dead_end) or true_last_room != "Duc7") and not duct_heater_memory["7"]["on"]:
			next_room = "Duc7"
		elif ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		else:
			next_room = "Duc1"

func decide_pas(dead_end): # esta es la más compleja, pues es la única en la que realmente hay varias decisiones igual de buenas
	
	if position == 0: # se que... pero bueno
		if true_last_room != "Duc3" and not duct_heater_memory["3"]["on"] and true_last_room != "Duc4" and not duct_heater_memory["4"]["on"] and true_last_room != "Duc5" and not duct_heater_memory["5"]["on"]:
			var rand_go_to = randi_range(0, 5)
			if rand_go_to == 0:
				next_room = "Duc3"
			elif rand_go_to == 1:
				next_room = "Duc4"
			else:
				next_room = "Duc5"
		elif (true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		elif (true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif (true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		elif (true_last_room != "Duc5" or dead_end) and not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		elif (true_last_room != "Duc3" or dead_end) and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		elif (true_last_room != "Duc4" or dead_end) and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		else: 
			next_room = "0"

	
	if position == 1:
		if ((true_last_room == "Duc5" and dead_end) or true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		else:
			if true_last_room != "Duc3" and not duct_heater_memory["3"]["on"] and true_last_room != "Duc4" and not duct_heater_memory["4"]["on"]:
				var rand_go_to = randi_range(0, 1)
				if rand_go_to == 0:
					next_room = "Duc3"
				else:
					next_room = "Duc4"
			elif (true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
				next_room = "Duc3"
			elif (true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
				next_room = "Duc4"
			elif (true_last_room != "Duc3" or dead_end) and not duct_heater_memory["3"]["on"]:
				next_room = "Duc3"
			elif (true_last_room != "Duc4" or dead_end) and not duct_heater_memory["4"]["on"]:
				next_room = "Duc4"
			else: 
				next_room = "0"
	
	if position == 2:
		if ((true_last_room == "Duc4" and dead_end) or true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
			next_room = "Duc4"
		else:
			if true_last_room != "Duc3" and not duct_heater_memory["3"]["on"] and true_last_room != "Duc5" and not duct_heater_memory["5"]["on"]:
				var rand_go_to = randi_range(0, 2)
				if rand_go_to == 0:
					next_room = "Duc3"
				else:
					next_room = "Duc5"
			elif (true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
				next_room = "Duc3"
			elif (true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
				next_room = "Duc5"
			elif (true_last_room != "Duc3" or dead_end) and not duct_heater_memory["3"]["on"]:
				next_room = "Duc3"
			elif (true_last_room != "Duc5" or dead_end) and not duct_heater_memory["5"]["on"]:
				next_room = "Duc5"
			else: 
				next_room = "0"
	
	if position == 3:
		if ((true_last_room == "Duc3" and dead_end) or true_last_room != "Duc3") and not duct_heater_memory["3"]["on"]:
			next_room = "Duc3"
		else:
			if true_last_room != "Duc4" and not duct_heater_memory["4"]["on"] and true_last_room != "Duc5" and not duct_heater_memory["5"]["on"]:
				var rand_go_to = randi_range(0, 2)
				if rand_go_to == 0:
					next_room = "Duc4"
				else:
					next_room = "Duc5"
			elif (true_last_room != "Duc4") and not duct_heater_memory["4"]["on"]:
				next_room = "Duc4"
			elif (true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
				next_room = "Duc5"
			elif (true_last_room != "Duc4" or dead_end) and not duct_heater_memory["4"]["on"]:
				next_room = "Duc4"
			elif (true_last_room != "Duc5" or dead_end) and not duct_heater_memory["5"]["on"]:
				next_room = "Duc5"
			else: 
				next_room = "0"

func decide_entrance(dead_end): # por fin una sencillita
	
	if ((true_last_room == "Duc6" and dead_end) or true_last_room != "Duc6") and not duct_heater_memory["6"]["on"]:
		next_room = "Duc6"
	else:
		next_room = "main"

func decide_kitchen(dead_end):
	
	if ((true_last_room == "Duc6" and dead_end) or true_last_room != "Duc6") and not duct_heater_memory["6"]["on"]:
		next_room = "Duc6"
	elif not duct_heater_memory["4"]["on"]:
		next_room = "Duc4"
	else:
		next_room = "0"

func decide_almacen(dead_end): # aunque hay 2 posiciones posibles, siempre intentará ir a Duc8
	
	if ((true_last_room == "Duc8" and dead_end) or true_last_room != "Duc8") and not duct_heater_memory["8"]["on"]:
		next_room = "Duc8"
	elif not duct_heater_memory["6"]["on"]:
		next_room = "Duc6"
	else:
		next_room = "0"

func decide_closet(dead_end):
	
	if ((true_last_room == "Duc8" and dead_end) or true_last_room != "Duc8") and not duct_heater_memory["8"]["on"]:
		next_room = "Duc8"
	elif not duct_heater_memory["7"]["on"]:
		next_room = "Duc7"
	else:
		next_room = "0"

func decide_lhall(dead_end, bonnie := false):
	
	if position == 0:
		if not door_I_closed and not bonnie:
			next_room = "office"
		elif true_last_room != "Duc5" and not duct_heater_memory["5"]["on"]: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc5"
		elif not duct_heater_memory["8"]["on"]:
			next_room = "Duc8"
		elif not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		else:
			var rand_go = randi_range(0, 2) # hago que decida entre quedarse o volver a revisar algun ducto, porque si lo encierras en el pasillo, se queda demasiado tiempo en la puerta
			if rand_go == 1:
				duct_heater_memory["5"]["on"] = false
				duct_heater_memory["5"]["time"] = 0
				next_room = "Duc5"
			elif rand_go == 2:
				duct_heater_memory["8"]["on"] = false
				duct_heater_memory["8"]["time"] = 0
				next_room = "Duc8"
			else:
				next_room = "0"
	
	if position == 1:
		if ((true_last_room == "Duc5" and dead_end) or true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		elif not duct_heater_memory["8"]["on"] and randi_range(0, 1) == 1: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc8"
		elif Bonnie.position != "PI":
			next_room = "office"
		else:
			next_room = "Duc8"
	
	if position == 2:
		if ((true_last_room == "Duc8" and dead_end) or true_last_room != "Duc8") and not duct_heater_memory["8"]["on"]:
			next_room = "Duc8"
		elif not duct_heater_memory["5"]["on"] and randi_range(0, 1) == 1: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc5"
		elif Bonnie.position != "PI":
			next_room = "office"
		else:
			next_room = "Duc5"

func decide_rhall(dead_end, chica := false): # exactamente igual que lhall
	
	if position == 0:
		if not door_D_closed and not chica:
			next_room = "office"
		elif true_last_room != "Duc5" and not duct_heater_memory["5"]["on"]: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc5"
		elif not duct_heater_memory["8"]["on"]:
			next_room = "Duc8"
		elif not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		else:
			var rand_go = randi_range(0, 2) # hago que decida entre quedarse o volver a revisar algun ducto, porque si lo encierras en el pasillo, se queda demasiado tiempo en la puerta
			if rand_go == 1:
				duct_heater_memory["5"]["on"] = false
				duct_heater_memory["5"]["time"] = 0
				next_room = "Duc5"
			elif rand_go == 2:
				duct_heater_memory["8"]["on"] = false
				duct_heater_memory["8"]["time"] = 0
				next_room = "Duc8"
			else:
				next_room = "0"
	
	if position == 1:
		if ((true_last_room == "Duc5" and dead_end) or true_last_room != "Duc5") and not duct_heater_memory["5"]["on"]:
			next_room = "Duc5"
		elif not duct_heater_memory["8"]["on"] and randi_range(0, 1) == 1: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc8"
		elif Chica.position != "PD":
			next_room = "office"
		else:
			next_room = "Duc8"
	
	if position == 2:
		if ((true_last_room == "Duc8" and dead_end) or true_last_room != "Duc8") and not duct_heater_memory["8"]["on"]:
			next_room = "Duc8"
		elif not duct_heater_memory["5"]["on"] and randi_range(0, 1) == 1: # 50 % de probabilidades de pasar por position 0 y atacar por la puerta
			next_room = "Duc5"
		elif Chica.position != "PD":
			next_room = "office"
		else:
			next_room = "Duc5"

func decide_Duc1(_dead_end):
	
	if duct_heater_memory["1"]["on"]:
		if position == 1:
			next_room = "main"
		if position == 2:
			if true_last_room == "main":
				next_room = "arcade"
			else:
				next_room = "main"
		if position == 3:
			next_room = "arcade"
	
	else:
		if true_last_room == "main":
			next_room = "arcade"
		else:
			next_room = "main"

func decide_Duc2(_dead_end): # controlaré el salir antes o despues en move dependiendo del heater
	
	next_room = "arcade"

func decide_Duc3(_dead_end):
	
	if duct_heater_memory["3"]["on"]:
		if position == 1:
			next_room = "arcade"
		if position == 2:
			if true_last_room == "main" or true_last_room == "pas":
				next_room = "arcade"
			else:
				next_room = "main"
		if position == 3:
			next_room = "main"
		if position == 4:
			next_room = "pas"
	
	else:
		if true_last_room == "pas":
			next_room = "arcade"
		elif true_last_room == "arcade":
			next_room = "pas"
		else:
			next_room = "pas"

func decide_Duc4(_dead_end):
	
	if duct_heater_memory["4"]["on"]:
		if position == 1:
			next_room = "pas"
		if position == 2:
			next_room = "main"
		if position == 3:
			if true_last_room == "main" or true_last_room == "pas":
				next_room = "kitchen"
			else:
				next_room = "main"
		if position == 4:
			next_room = "kitchen"
	
	else:
		if true_last_room == "pas":
			next_room = "kitchen"
		elif true_last_room == "kitchen":
			next_room = "pas"
		else:
			next_room = "pas"

func decide_Duc5(_dead_end):
	
	if duct_heater_memory["5"]["on"]: # dependiendo del nivel de AI, será más facil echarle a pas
		if position == 0:
			next_room = "office"
		if position == 1:
			next_room = "lhall"
		
		if position == 2:
			var rand_go_to_pas: int
			rand_go_to_pas = randi_range(0, 20) # esto hace más sencillo hechar a foxy a pas
			if AI_level > rand_go_to_pas:
				next_room = "lhall"
			else:
				next_room = "lhall"
		
		if position == 3:
			next_room = "pas"
		
		if position == 4: 
			var rand_go_to_pas: int
			rand_go_to_pas = randi_range(0, 20) # esto hace más sencillo hechar a foxy a pas
			if AI_level > rand_go_to_pas:
				next_room = "rhall"
			else:
				next_room = "rhall"
		
		if position == 5:
			next_room = "rhall"
	
	else:
		next_room = "office"

func decide_Duc6(_dead_end):
	
	if duct_heater_memory["6"]["on"]:
		if position == 1:
			next_room = "entrance"
		if position == 2:
			next_room = "kitchen"
		if position == 3:
			if true_last_room == "almacen":
				next_room = "kitchen"
			else:
				next_room = "almacen"
		if position == 4:
				next_room = "almacen"
	
	else:
		if true_last_room == "almacen":
			next_room = "kitchen"
		else:
			next_room = "almacen"

func decide_Duc7(_dead_end):
	
	if duct_heater_memory["7"]["on"]:
		if position == 1:
			next_room = "arcade"
		if position == 2:
			next_room = "closet"
	
	else:
		if true_last_room == "arcade":
			next_room = "closet"
		else:
			next_room = "arcade"

func decide_Duc8(_dead_end):
	
	if duct_heater_memory["8"]["on"]:
		if position == 0:
			next_room = "office"
		if position == 1:
			next_room = "closet"
		if position == 2 or position == 3:
			next_room = "lhall"
		if position == 4:
			if randi_range(0, 1) == 0:
				next_room = "lhall"
			else:
				next_room = "rhall"
		if position == 5 or position == 6:
			next_room = "rhall"
		if position == 7:
			next_room = "almacen"
	
	else:
		next_room = "office"


#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall, office
func move_main():
	
	if next_room == "Duc1":
		if position > 1:
			position -= 1
		else:
			room = next_room
			position = 1 # suerte que coinciden
	
	elif next_room == "Duc3":
		if position < 2:
			position += 1
		elif position == 2:
			room = next_room
			position = 3
		else:
			position -= 1
	
	elif next_room == "Duc4":
		if position < 4:
			position += 1
		elif position == 4:
			room = next_room
			position = 2
		else:
			position -= 1
	
	elif next_room == "entrance":
		if position < 5:
			position += 1
		else:
			room = next_room
			position = 1
	
	else:
		pass

func move_arcade(): # nunca va a ir a Duc1 desde arcade # SI QUE VA A IR A DUC1 DESDE ARCADE QUE COJONES DIGO?????
	
	if next_room == "Duc2":
		if position != 3:
			room = next_room
			if position == 1:
				position = 1
			elif position == 2:
				position = 3
			else:
				position = 5
		else:
			position += 1
	
	elif next_room == "Duc3":
		if position < 3:
			position += 1
		elif position == 3:
			room = next_room
			position = 1
		else:
			position -= 1
	
	elif next_room == "Duc7":
		if position == 3 or position == 1:
			position += 1
		elif position == 2:
			position = 4
		elif position == 4:
			room = next_room
			position = 1
	
	elif next_room == "Duc1":
		if position == 1:
			room = next_room
			position = 3
		else:
			if position == 4:
				position = 2
			else:
				position -= 1
	
	else:
		pass

func move_pas():
	
	if next_room == "Duc3":
		if position != 3:
			position = 3
		else:
			room = next_room
			position = 4
	
	elif next_room == "Duc4":
		if position != 2:
			position = 2
		else:
			room = next_room
			position = 1
	
	elif next_room == "Duc5":
		if position != 1:
			position = 1
		else:
			room = next_room
			position = 3
	
	else:
		pass

func move_entrance():
	
	if next_room == "main":
		room = next_room
		position = 5
	else:
		room = next_room
		position = 1

func move_kitchen():
	
	if next_room == "Duc6":
		room = next_room
		position = 2
	elif next_room == "Duc4":
		room = next_room
		position = 4
	else:
		pass

func move_almacen():
	
	if next_room == "Duc8":
		if position == 1:
			position += 1
		else:
			room = next_room
			position = 7
	elif next_room == "Duc6":
		if position == 2:
			position -= 1
		else:
			room = next_room
			position = 4
	else:
		pass

func move_closet():
	
	if next_room == "Duc7":
		room = next_room
		position = 2
	elif next_room == "Duc8":
		room = next_room
		position = 1
	else:
		pass

func move_lhall():
	
	if next_room == "Duc8":
		if position != 2:
			position = 2
		else:
			room = next_room 
			position = 2
	elif next_room == "Duc5":
		if position != 1:
			position = 1
		else:
			room = next_room
			position = 1
	elif next_room == "office":
		if position != 0:
			position = 0
			lock_movement = true
		elif not door_I_closed:
			room = next_room # office no tiene posicion...
			#print("Door I: ", door_I_closed)
		else:
			pass
	else:
		pass

func move_rhall():
	
	if next_room == "Duc8":
		if position != 2:
			position = 2
		else:
			room = next_room 
			position = 6
	elif next_room == "Duc5":
		if position != 1:
			position = 1
		else:
			room = next_room
			position = 5
	elif next_room == "office":
		if position != 0:
			position = 0
			lock_movement = true
		elif not door_D_closed:
			room = next_room # office no tiene posicion...
			#print("Door D: ", door_D_closed)
		else:
			pass
	else:
		pass

func move_Duc1():
	
	if next_room == "main":
		if position != 1:
			position -= 1
		else:
			room = next_room 
			position = 1
	elif next_room == "arcade":
		if position != 3:
			position += 1
		else:
			room = next_room
			position = 1

func move_Duc2():
	
	if duct_heater_memory["2"]["on"]:
		if position == 1:
			room = next_room
			position = 1
		if position == 3:
			room = next_room
			position = 2
		if position == 5:
			room = next_room
			position = 4
		if position == 2 or position == 4:
			position += 1
	else:
		if position != 5:
			position += 1
		else:
			room = next_room
			position = 4

func move_Duc3():
	
	if next_room == "main":
		if position > 3:
			position -= 1
		elif position < 3:
			position += 1
		else:
			room = next_room 
			position = 2
	elif next_room == "arcade":
		if position != 1:
			position -= 1
		else:
			room = next_room
			position = 3
	elif next_room == "pas":
		if position != 4:
			position += 1
		else:
			room = next_room
			position = 3

func move_Duc4():
	
	if next_room == "main":
		if position > 2:
			position -= 1
		elif position < 2:
			position += 1
		else:
			room = next_room 
			position = 4
	elif next_room == "kitchen":
		if position != 4:
			position += 1
		else:
			room = next_room
			position = 1
	elif next_room == "pas":
		if position != 1:
			position -= 1
		else:
			room = next_room
			position = 2

func move_Duc5():
	
	if next_room == "pas":
		if position > 3:
			position -= 1
		elif position < 3:
			position += 1
		else:
			room = next_room 
			position = 1
	elif next_room == "rhall":
		if position != 5:
			position += 1
		else:
			room = next_room
			position = 1
	elif next_room == "lhall":
		if position != 1:
			position -= 1
		else:
			room = next_room
			position = 1
	if next_room == "office":
		if position == 0:
			room = next_room
		elif position > 3:
			position -= 1
		elif position < 3:
			position += 1
		elif position == 3:
			position = 0
			lock_movement = true

func move_Duc6():
	
	if next_room == "entrance":
		if position != 1:
			position -= 1
		else:
			room = next_room 
			position = 1
	elif next_room == "kitchen":
		if position < 2:
			position += 1
		elif position > 2:
			position -= 1
		else:
			room = next_room
			position = 1
	elif next_room == "almacen":
		if position != 4:
			position += 1
		else:
			room = next_room 
			position = 1

func move_Duc7():
	
	if next_room == "arcade":
		if position != 1:
			position = 1
		else:
			room = next_room 
			position = 4
	elif next_room == "closet":
		if position != 2:
			position = 2
		else:
			room = next_room
			position = 1

func move_Duc8():
	
	if next_room == "rhall":
		if position > 6:
			position -= 1
		elif position < 6:
			position += 1
		else:
			room = next_room 
			position = 2
	elif next_room == "lhall":
		if position > 2:
			position -= 1
		elif position < 2:
			position += 1
		else:
			room = next_room 
			position = 2
	elif next_room == "almacen":
		if position != 7:
			position += 1
		else:
			room = next_room
			position = 2
	elif next_room == "closet":
		if position != 1:
			position -= 1
		else:
			room = next_room
			position = 1
	if next_room == "office":
		if position == 0:
			room = next_room
		elif position == 4:
			position = 0
			lock_movement = true
		elif position > 4:
			position -= 1
		elif position < 4:
			position += 1
