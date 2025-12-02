extends Node

var language := "En" #Gcontrol
var audio_language := "En" #Gcontrol

var minigame_text_speed_mult := 1.0

var noche := 1 # 1-6, 0 es custom night.
var custom_night_ai := [0, 0, 0, 0] # bonnie, chica, freddy, foxy
var custom_night := false

var true_night_6 := false # para saber cuando tienes lo necesario para los finales verdaderos en la noche 6
var safe_code := [2, 7, 3, 5, 3] # el codigo en orden de la caja
var location_key := 0
var m_entering := true

func randomize_safe_code():
	if debug["game_state"]["override"] and debug["game_state"]["force_combination"]:
		var digits := []
		for ch in str(debug["game_state"]["combination"]):
			digits.append(int(ch))
			if len(digits) == 5:
				break
		Global.safe_code = digits
	else:
		for i in range(0, 5):
			Global.safe_code[i] = randi_range(1, 9)
		print("Safe code set: ", Global.safe_code)

var inventario :={
	"key": false,
	"recorder": false,
	"screwdriver": false,
	"bateries": false,
	"chair": false,
	"files": false,
	"usb_key": false,
	"exe": false,
}

var mapa :={
	"door_office_open": false,
	"safe_open": false,
	"safe_opened_by_animatronic": false,
	"recorder_planted": false,
	"computer_working": false,
	"computer_failed": false,
	"signed_in": false,
}


var debug :={
	"debug_mode": false,
	"prevent_save": false,
	"cheats": {
		"invencibility": false,
		"instawin": false,
		"timeless": false,
		"ultra_agresive": false,
		"infinite_light": false,
		"lights_consume": false,
		"animatronic_map": false,
		"see_light_batery": false,
		"see_insanity": false,
		"see_time_always": false,
		"tick_count": false,
		"max_consumption": 3,
		"tick_rate": 5,
		"night_duration": 5,
	},
	"game_state": {
		"override": false,
		"night": 1,
		"true_night_6": false,
		"force_enter": false,
		"force_exit": false,
		"force_combination": false,
		"combination": 11111,
		"mapa": {
			"door_office_open": false,
			"safe_open": false,
			"safe_opened_by_animatronic": false,
			"recorder_planted": false,
			"computer_working": false,
			"computer_failed": false,
			"signed_in": false,
		},
		"inventario": {
			"key": false,
			"recorder": false,
			"screwdriver": false,
			"bateries": false,
			"files": false,
			"usb_key": false,
			"exe": false,
		},
	},
}

var idle_debug := debug.duplicate(true)

func reset_debug():
	debug = idle_debug
	leer_progreso()
	leer_partida()

func create_new_game():
	eliminar_partida()
	for key in mapa: # reinicia todos los elementos
		mapa[key] = false
	for key in inventario:
		inventario[key] = false
	noche = 1
	true_night_6 = false
	safe_code = [0,0,0,0,0]


var timeless: bool
var time_hour: int
var time_minute: int
var tick_count: int
var night_speed := 1


func minigame_starts():
	
	if debug["game_state"]["override"]:
		chage_game_state_to_debug()
		return
	
	leer_partida()
	
	if noche == 5:
		if m_entering:
			randomize_safe_code()
		elif mapa["door_office_open"]:
			mapa["safe_opened_by_animatronic"] = true
	
	if m_entering:
		mapa["safe_opened_by_animatronic"] = false
		mapa["door_office_open"] = false

func chage_game_state_to_debug():
	if debug["game_state"]["override"] == false: # capa extra de seguridad, por si acaso...
		return
	if debug["game_state"]["force_combination"]:
			randomize_safe_code()
	noche = debug["game_state"]["night"]
	true_night_6 = debug["game_state"]["true_night_6"]
	if debug["game_state"]["force_enter"]:
		m_entering = true
	elif debug["game_state"]["force_exit"]:
		m_entering = false
	for key in mapa:
		mapa[key] = debug["game_state"]["mapa"][key]
	for key in debug["game_state"]["inventario"]:
		inventario[key] = debug["game_state"]["inventario"][key]

func night_starts():
	
	if noche == 0:
		return
	
	if noche == 4:
		location_key = randi_range(1,3)
	
	mapa["computer_failed"] = false
	if mapa["computer_working"]:
		set_energia_consumption("Especial", 1)

var linterna_bateria := 100:
	get: return linterna_bateria
	set(valor): linterna_bateria = clamp(valor, 0.0, 100.0)
var linterna_bateria_show_anyways_because_i_dont_find_another_good_solution := false

signal Energy_Breakdown
signal act_ai_state

var insanity: int # con 1000 te desmayas

func tick():
	
	if debug["debug_mode"] and debug["cheats"]["instawin"]:
		time_hour = 6
	
	if not energia["Ventilacion"]:
		if not energia["General"]:
			insanity += 1
		else:
			insanity += 3
	
	tick_count += 1
	if tick_count == night_speed:
		tick_count = 0
		time_minute += 1
		if insanity > 0 and energia["Ventilacion"]:
			if insanity > 999:
				insanity = 999
			else:
				insanity -= 1 # de momento voy a hacer que la insanidad baje en 1 cada 5 ticks...
		if time_minute == 60:
			time_minute = 0
			time_hour += 1
			if time_hour < 6:
				act_animatronic_ai(time_hour)
	
	if timeless:
		time_minute = 0
		time_hour = 0

func act_animatronic_ai(hour: int):
	
	if noche == 0:
		if hour != 0:
			return
		Bonnie.AI_level = custom_night_ai[0]
		Chica.AI_level = custom_night_ai[1]
		Freddy.AI_level = custom_night_ai[2]
		Foxy.AI_level = custom_night_ai[3]
		
	
	var bonnie_new_ai = get_night_info("bonnie", noche, hour)
	if bonnie_new_ai != null:
		Bonnie.AI_level = bonnie_new_ai
	
	var chica_new_ai = get_night_info("chica", noche, hour)
	if chica_new_ai != null:
		Chica.AI_level = chica_new_ai
	
	var freddy_new_ai = get_night_info("freddy", noche, hour)
	if freddy_new_ai != null:
		Freddy.AI_level = freddy_new_ai
	
	var foxy_new_ai = get_night_info("foxy", noche, hour)
	if foxy_new_ai != null:
		Foxy.AI_level = foxy_new_ai
	
	emit_signal("act_ai_state")

var energia_consumption :={
	"Max": 3,
	"Total": 0,
	"Ventilacion": false,
	"Luces": false,
	"Lights_Consume": false,
	"Cam_lights": false,
	"Puerta_I": false,
	"Puerta_D": false,
	"Linterna_Rec": false,
	"Camaras": false,
	"Heater": 0,
	"Especial": 0
}

func print_energia_consumption():
	var salida := "\n--- Estado de energía ---\n"
	for clave in energia_consumption.keys():
		salida += "%s: %s\n" % [clave, str(energia_consumption[clave])]
	print(salida)

func set_energia_consumption(nombre: String, valor: int):
	if nombre == "Heater" or nombre == "Especial":
		if energia_consumption.has(nombre):
			energia_consumption[nombre] = valor
	else:
		if energia_consumption.has(nombre):
			if valor == 0:
				energia_consumption[nombre] = false
			elif valor == 1:
				energia_consumption[nombre] = true
	
	consumtion()
	
	if energia_consumption["Total"] > energia_consumption["Max"]:
		if mapa["computer_working"]:
			mapa["computer_failed"] = true
			set_energia_consumption("Especial", 0)
		emit_signal("Energy_Breakdown")
		actualizar_ventilacion()

func consumtion():
	energia_consumption["Total"] = 0
	if energia_consumption["Ventilacion"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Puerta_I"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Luces"] and energia_consumption["Lights_Consume"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Cam_lights"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Puerta_D"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Linterna_Rec"]:
		energia_consumption["Total"] += 1
	if energia_consumption["Camaras"]:
		energia_consumption["Total"] += 1
	energia_consumption["Total"] += energia_consumption["Heater"]
	energia_consumption["Total"] += energia_consumption["Especial"]

func actualizar_ventilacion():
	if energia["Ventilacion"] == energia_consumption["Ventilacion"]:
		return
	if energia["Ventilacion"]:
		Global.set_energia_consumption("Ventilacion", 1)
	elif energia["Ventilacion"] == false:
		Global.set_energia_consumption("Ventilacion", 0)

func actualizar_luces():
	if energia["Luces"]:
		Global.set_energia_consumption("Luces", 1)
	elif energia["Luces"] == false:
		Global.set_energia_consumption("Luces", 0)

signal energia_actualizada

var energia := { # swithces
	"General": true,
	"Luces": true,
	"Ventilacion": true,
	"Puertas": true,
	"Linterna": true,
	"Camaras": true,
	"Heater": false
}

func set_energia(nombre: String, valor: bool):
		
	if nombre == "General" and valor == false:
		for key in energia.keys():
			if energia[key] != false:
				energia[key] = false
		emit_signal("energia_actualizada")
		actualizar_luces()
		return
		
	if energia.has(nombre) and energia[nombre] != valor:
		energia[nombre] = valor
		emit_signal("energia_actualizada")
		actualizar_ventilacion()
		actualizar_luces()


var escena_previa: String

func reset():
	insanity = 0
	time_hour = 0
	time_minute = 0
	tick_count = 0
	linterna_bateria = 100
	energia = { # reinicia swithces
		"General": true,
		"Luces": true,
		"Ventilacion": true,
		"Puertas": true,
		"Linterna": true,
		"Camaras": true,
		"Heater": true
	}
	act_animatronic_ai(0)

func get_night_info(animatronic: String, night: int, time: int):
	var row: int
	var column := 2 + (night - 1) * 6 + time
	
	if animatronic == "bonnie":
		row = 2
	elif animatronic == "chica":
		row = 3
	elif animatronic == "freddy":
		row = 4
	elif animatronic == "foxy":
		row = 5
	
	return get_csv_value(row, column)

func get_csv_value(row_index: int, col_index: int): # Chat GPT... #Gcontrol
	var path := "res://Data/Night_database.csv"
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("No se pudo abrir el archivo CSV: " + path)
		return null
	
	var table: Array = []
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line != "":
			table.append(line.split(",")) # Cada línea → Array de strings
	file.close()
	
	# Ajustamos porque el usuario usa índices desde 1, pero en arrays es desde 0
	var r = row_index - 1
	var c = col_index - 1
	
	if r < 0 or r >= table.size():
		return null
	if c < 0 or c >= table[r].size():
		return null
	
	var cell = table[r][c].strip_edges()
	return cell if cell != "" else null


var dead_scene_type := 0


var mouse_custom_op := 1.0
@export_enum("1", "2", "3", "4", "5")
var mouse_custom_punt: String = "3"
var mouse_cam_see := true

# Para la skin de la linterna
var linterna_skin := {
	"alpha_general": 1.0,
	"alpha_base": 1.0,
	"partes": {
		"Paleta_A": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 1.0, "visible": true},
			"4":  {"alpha": 1.0, "visible": true},
			"5":  {"alpha": 1.0, "visible": true},
		},
		"Paleta_B": {
			"1":  {"alpha": 1.0, "visible": true},
			"2":  {"alpha": 1.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true},
			"4":  {"alpha": 0.0, "visible": true},
			"5":  {"alpha": 0.0, "visible": true},
		},
		"Paleta_C": {
			"1":  {"alpha": 0.5, "visible": true},
			"2":  {"alpha": 0.5, "visible": true},
			"3":  {"alpha": 0.5, "visible": true},
			"4":  {"alpha": 0.5, "visible": true},
			"5":  {"alpha": 0.5, "visible": true},
		},
		"Paleta_D": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true},
			"4":  {"alpha": 0.0, "visible": true},
			"5":  {"alpha": 0.0, "visible": true},
		},
		"Paleta_E": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true},
			"4":  {"alpha": 0.0, "visible": true},
			"5":  {"alpha": 0.0, "visible": true},
		},
		"Paleta_F": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true},
			"4":  {"alpha": 0.0, "visible": true},
			"5":  {"alpha": 0.0, "visible": true},
		}
	}
}

# Para la skin de la energia
var energia_skin := {
	"alpha_general": 1.0,
	"alpha_base": 1.0,
	"partes": {
		"Paleta_A": {
			"1":  {"alpha": 1.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true}
		},
		"Paleta_B": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 1.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true}
		},
		"Paleta_C": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 1.0, "visible": true}
		},
		"Paleta_D": {
			"1":  {"alpha": 0.5, "visible": true},
			"2":  {"alpha": 0.5, "visible": true},
			"3":  {"alpha": 0.5, "visible": true}
		},
		"Paleta_E": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true}
		},
		"Paleta_F": {
			"1":  {"alpha": 0.0, "visible": true},
			"2":  {"alpha": 0.0, "visible": true},
			"3":  {"alpha": 0.0, "visible": true}
		}
	}
}

var fade := {
	"Energia": {
		"Active": true,
		"Time": 1.5,
		"Speed": 2.0
	},
	"Linterna": {
		"Active": true,
		"Time": 1.0,
		"Speed": 2.0
	}
}

var misc := {
	"Switch_Doors_Back": true,
	"Auto_cam_lights": true,
	"When_dead_go_to": "night",
	"When_win_go_to": "shift",
}


#guardado:

var config_default

func _ready():
	
	leer_progreso()
	if not FileAccess.file_exists("user://progreso.json"):
		guardar_progreso()
	leer_partida()
	
	config_default = {
		"language": language,
		"audio_language": audio_language,
		"minigame_text_speed_mult": minigame_text_speed_mult,
		"mouse_custom_op": mouse_custom_op,
		"mouse_custom_punt": mouse_custom_punt,
		"mouse_cam_see": mouse_cam_see,
		"linterna_skin": linterna_skin,
		"energia_skin": energia_skin,
		"fade": fade,
		"misc": misc,
		"audio": {
			"master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
			"musica": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")),
			"sfx": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")),
			}
	}
	
	leer_configuration()



func guardar_configuration():
	
	var configuration := {
		"language": language,
		"audio_language": audio_language,
		"minigame_text_speed_mult": minigame_text_speed_mult,
		"mouse_custom_op": mouse_custom_op,
		"mouse_custom_punt": mouse_custom_punt,
		"mouse_cam_see": mouse_cam_see,
		"linterna_skin": linterna_skin,
		"energia_skin": energia_skin,
		"fade": fade,
		"misc": misc,
		"audio": {
			"master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
			"musica": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")),
			"sfx": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")),
		}
	}
	if configuration["mouse_custom_op"] < 0.5:
		configuration["mouse_custom_op"] = 0.5
	
	var path := "user://config.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(configuration)) # "\t" = formato legible
		file.close()
		print("Configuración guardada")
	else:
		print("Configuración fallida")


func leer_configuration():
	
	var path = "user://config.json"
	if not FileAccess.file_exists(path):
		print("No existe el archivo de configuración.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var configuration = JSON.parse_string(text)
	if configuration == null:
		print("Error al leer JSON.")
		return
	
	# Cargar variables
	language = configuration.get("language", language)
	audio_language = configuration.get("audio_language", audio_language)
	minigame_text_speed_mult = configuration.get("minigame_text_speed_mult", minigame_text_speed_mult)
	mouse_custom_op = configuration.get("mouse_custom_op", mouse_custom_op)
	mouse_custom_punt = configuration.get("mouse_custom_punt", mouse_custom_punt)
	mouse_cam_see = configuration.get("mouse_cam_see", mouse_cam_see)
	linterna_skin = configuration.get("linterna_skin", linterna_skin)
	energia_skin = configuration.get("energia_skin", energia_skin)
	fade = configuration.get("fade", fade)
	misc = configuration.get("misc", misc)
	
	if configuration.has("audio"):
		var audio = configuration["audio"]
		if audio.has("master"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), audio["master"])
		if audio.has("musica"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), audio["musica"])
		if audio.has("sfx"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), audio["sfx"])
	
	print("Configuración cargada")


func reset_configuration():
	if config_default == null:
		return
	language = config_default.get("language", language)
	audio_language = config_default.get("audio_language", audio_language)
	minigame_text_speed_mult = config_default.get("minigame_text_speed_mult", minigame_text_speed_mult)
	mouse_custom_op = config_default.get("mouse_custom_op", mouse_custom_op)
	mouse_custom_punt = config_default.get("mouse_custom_punt", mouse_custom_punt)
	mouse_cam_see = config_default.get("mouse_cam_see", mouse_cam_see)
	linterna_skin = config_default.get("linterna_skin", linterna_skin)
	energia_skin = config_default.get("energia_skin", energia_skin)
	fade = config_default.get("fade", fade)
	misc = config_default.get("misc", misc)
	if config_default.has("audio"):
		var audio = config_default["audio"]
		if audio.has("master"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), audio["master"])
		if audio.has("musica"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), audio["musica"])
		if audio.has("sfx"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), audio["sfx"])


func delete_config_file():
	var path = "user://config.json"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)


func guardar_partida():
	
	if debug["prevent_save"]:
		return
	
	var partida := {
		"noche": noche,
		"true_night_6": true_night_6,
		"safe_code": safe_code,
		"inventario": inventario,
		"mapa": mapa,
	}
	
	var path := "user://partida.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(partida)) # "\t" = formato legible
		file.close()
		print("Partida guardada")
	else:
		print("Partida fallida")


func leer_partida():
	var path = "user://partida.json"
	if not FileAccess.file_exists(path):
		print("No existe el archivo de partida.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var partida = JSON.parse_string(text)
	if partida == null:
		print("Error al leer JSON.")
		return
	
	# Cargar variables
	
	noche = partida.get("noche", noche)
	true_night_6 = partida.get("true_night_6", true_night_6)
	safe_code = partida.get("safe_code", safe_code)
	inventario = partida.get("inventario", inventario)
	mapa = partida.get("mapa", mapa)
	
	print("Partida cargada")

func eliminar_partida():
	var path = "user://partida.json"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)


var finales := {
	"mediocre": false,
	"party": false,
	"bad": false,
	"good": false,
	"420": false,
}

func guardar_progreso():
	if debug["prevent_save"]:
		return
	
	var progreso := {
		"custom_night": custom_night,
		"finales": finales,
	}
	
	var path := "user://progreso.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(progreso)) # "\t" = formato legible
		file.close()
		print("Progreso guardado")
	else:
		print("Progreso fallido")


func leer_progreso():
	var path = "user://progreso.json"
	if not FileAccess.file_exists(path):
		print("No existe el archivo de progreso.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var partida = JSON.parse_string(text)
	if partida == null:
		print("Error al leer JSON.")
		return
	
	custom_night = partida.get("custom_night", custom_night)
	finales = partida.get("finales", finales)
	
	print("Progreso cargado")


func eliminar_progreso():
	var path = "user://progreso.json"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
