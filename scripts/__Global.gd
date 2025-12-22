extends Node


#---Control Variables---#

const text_CSV_name: String = "Text_translated.csv"
const AI_CSV_name: String = "Night_database.csv"

const user_root: String = "user://"
const configuration_rout: String = "config.json"
const partida_rout: String = "partida.json"
const progreso_rout: String = "progreso.json"
const debug_partida_rout: String = "deb-partida.json"

var escena_previa: String
var dead_scene_type := 0
var killed_by := "none" # bonnie, chica, freddy, foxy. none es cuando no te ha matado nadie


#---Control Functions---#


#-text

func get_csv_value_int(csv:String, row_index: int, col_index: int): # Devuelve el valor de la casilla indicada del csv por las coordenadas
	var path := "res://Data/" + csv
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("No se pudo abrir el archivo CSV: " + path)
		return null
	
	var table: Array = []
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line != "":
			table.append(line.split(",")) # Cada línea → Array de strings
	file.close()
	
	# Ajustamos porque el csv usa índices desde 1, pero en arrays es desde 0
	var r = row_index - 1
	var c = col_index - 1
	
	if r < 0 or r >= table.size():
		return null
	if c < 0 or c >= table[r].size():
		return null
	
	var cell = table[r][c].strip_edges()
	return cell if cell != "" else null

func get_csv_value_id(csv:String, row_id: String, col_id: String) -> String: # Devuelve el valor de la casilla indicada del csv por las ids
	var path := "res://Data/" + csv
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("No se pudo abrir el archivo CSV: " + path)
		return "Something went wrong... (CSV not found)"
	
	# Leer la cabecera para encontrar el índice del idioma
	if file.eof_reached():
		return "Something went wrong... (empty CSV)"
	
	var header = file.get_csv_line()
	var col_index = header.find(col_id)
	if col_index == -1:
		return "Something went wrong... (Language not found: " + col_id + ")"
	
	# Buscar la fila correspondiente al row_id
	while not file.eof_reached():
		var columns = file.get_csv_line()
		if columns.size() == 0:
			continue
		
		if columns[0] == row_id:
			if col_index < 0 or col_index >= columns.size():
				return "Something went wrong... (col out of range)"
			var cell = columns[col_index].strip_edges()
			return cell if cell != "" else "Something went wrong... (empty cell)"
	
	file.close()
	return "Something went wrong... (id non existant)"

#-File Management

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
	
	var path := user_root + configuration_rout
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(configuration)) # "\t" = formato legible
		file.close()
		print("Configuración guardada")
	else:
		push_warning("Configuración fallida")

func leer_configuration():
	
	var path := user_root + configuration_rout
	if not FileAccess.file_exists(path):
		print("No existe el archivo de configuración.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var configuration = JSON.parse_string(text)
	if configuration == null:
		push_warning("Error al leer JSON.")
		return
	
	# Cargar variables
	language = configuration.get("language", language)
	audio_language = configuration.get("audio_language", audio_language)
	minigame_text_speed_mult = configuration.get("minigame_text_speed_mult", minigame_text_speed_mult)
	mouse_custom_op = configuration.get("mouse_custom_op", mouse_custom_op)
	mouse_custom_punt = configuration.get("mouse_custom_punt", mouse_custom_punt)
	mouse_cam_see = configuration.get("mouse_cam_see", mouse_cam_see)
	_asign_recursive_diccionary(configuration.get("linterna_skin"), linterna_skin)
	_asign_recursive_diccionary(configuration.get("energia_skin"), energia_skin)
	_asign_recursive_diccionary(configuration.get("fade"), fade)
	_asign_recursive_diccionary(configuration.get("misc"), misc)
	# Esto podria hacerlo metiendo toda la configuración en un diccionario y _asign(config, configuration), pero ya no voy a cambiar todo el codigo para ahorarme unas lineas
	
	if configuration.has("audio"):
		var audio = configuration["audio"]
		if audio.has("master"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), audio["master"])
		if audio.has("musica"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), audio["musica"])
		if audio.has("sfx"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), audio["sfx"])
	
	print("Configuración cargada")

func guardar_configuration_default():
	config_default = {
		"language": language,
		"audio_language": audio_language,
		"minigame_text_speed_mult": minigame_text_speed_mult,
		"mouse_custom_op": mouse_custom_op,
		"mouse_custom_punt": mouse_custom_punt,
		"mouse_cam_see": mouse_cam_see,
		"linterna_skin": linterna_skin.duplicate(true),
		"energia_skin": energia_skin.duplicate(true),
		"fade": fade.duplicate(true),
		"misc": misc.duplicate(true),
		"audio": {
			"master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
			"musica": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")),
			"sfx": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")),
			}
	}

func reset_configuration():
	if config_default == null:
		print("There is no defualt configuration")
		return
	language = config_default.get("language", language)
	audio_language = config_default.get("audio_language", audio_language)
	minigame_text_speed_mult = config_default.get("minigame_text_speed_mult", minigame_text_speed_mult)
	mouse_custom_op = config_default.get("mouse_custom_op", mouse_custom_op)
	mouse_custom_punt = config_default.get("mouse_custom_punt", mouse_custom_punt)
	mouse_cam_see = config_default.get("mouse_cam_see", mouse_cam_see)
	_asign_recursive_diccionary(config_default.get("linterna_skin"), linterna_skin)
	_asign_recursive_diccionary(config_default.get("energia_skin"), energia_skin)
	_asign_recursive_diccionary(config_default.get("fade"), fade)
	_asign_recursive_diccionary(config_default.get("misc"), misc)
	if config_default.has("audio"):
		var audio = config_default["audio"]
		if audio.has("master"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), audio["master"])
		if audio.has("musica"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), audio["musica"])
		if audio.has("sfx"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), audio["sfx"])

func delete_config_file():
	var path := user_root + configuration_rout
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)


func guardar_partida(use_debug_game_state_istead_of_normal := false):
	
	if debug["game_state"]["override"]:
		
		var devpartida: Dictionary
		
		if use_debug_game_state_istead_of_normal:
			devpartida = {
				"noche": debug["game_state"]["night"],
				"safe_code": debug["game_state"]["combination"],
				"inventario": debug["game_state"]["inventario"],
				"mapa": debug["game_state"]["mapa"],
				"dm": debug["game_state"]["dm"],
			}
		else:
			sync_debug_to_current()
			devpartida = {
				"noche": noche,
				"safe_code": safe_code,
				"inventario": inventario,
				"mapa": mapa,
				"dm": dm,
			}
		
		var devpath := user_root + debug_partida_rout
		var devfile := FileAccess.open(devpath, FileAccess.WRITE)
		
		if devfile:
			devfile.store_string(JSON.stringify(devpartida)) # "\t" = formato legible
			print("Debug partida guardada")
			devfile.close()
		else:
			push_warning("Debug partida fallida")
	
	if debug["prevent_save"]:
		return
	
	var partida := {
		"noche": noche,
		"safe_code": safe_code,
		"inventario": inventario,
		"mapa": mapa,
		"dm": dm,
	}
	
	var path := user_root + partida_rout
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(partida)) # "\t" = formato legible
		print("Partida guardada")
	else:
		push_warning("Partida fallida")
	file.close()

func guardar_death_minigames():
	
	if debug["game_state"]["override"]:
		
		var devpath := user_root + debug_partida_rout
		
		if not FileAccess.file_exists(devpath):
			print("No existe el archivo de partida.")
			return
		
		var devfile = FileAccess.open(devpath, FileAccess.READ)
		var devtext = devfile.get_as_text()
		devfile.close()
		
		var devpartida = JSON.parse_string(devtext) # Cargamos los archivos de partida
		if devpartida == null:
			push_warning("Error al leer JSON.")
			return
		
		devpartida["dm"] = debug["game_state"]["dm"]
		devpartida["mapa"]["death_minigames"] = true
		
		devfile = FileAccess.open(devpath, FileAccess.WRITE)
		
		if devfile:
			devfile.store_string(JSON.stringify(devpartida)) # "\t" = formato legible
			print("Partida guardada")
			devfile.close()
		else:
			push_warning("Partida fallida")
	
	if debug["prevent_save"]:
		return
	
	var path := user_root + partida_rout
	
	if not FileAccess.file_exists(path):
		print("No existe el archivo de partida.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var partida = JSON.parse_string(text) # Cargamos los archivos de partida
	if partida == null:
		print("Error al leer JSON.")
		return
	
	partida["dm"] = dm
	
	file = FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(partida)) # "\t" = formato legible
		print("Partida guardada")
	else:
		print("Partida fallida")
	file.close()

func leer_partida():
	
	if debug["game_state"]["override"]:
		
		#-Carga debug-
		
		var devpath := user_root + debug_partida_rout
		
		if FileAccess.file_exists(devpath):
			
			var devfile = FileAccess.open(devpath, FileAccess.READ)
			var devtext = devfile.get_as_text()
			devfile.close()
			
			var devpartida = JSON.parse_string(devtext)
			if devpartida == null:
				push_warning("Error al leer JSON.")
				return
			
			# Cargar variables
			
			noche = devpartida.get("noche", noche)
			safe_code = devpartida.get("safe_code", safe_code)
			_asign_recursive_diccionary(devpartida.get("inventario"), inventario)
			_asign_recursive_diccionary(devpartida.get("mapa"), mapa)
			_asign_recursive_diccionary(devpartida.get("dm"), dm)
			
			sync_debug_to_current()
			
			print("Debug partida cargada")
			return
		
		print("No existe el archivo de partida debug. Leyendo partida normal")
	
	#--Carga normal--
	
	var path := user_root + partida_rout
	
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
	safe_code = partida.get("safe_code", safe_code)
	_asign_recursive_diccionary(partida.get("inventario"), inventario)
	_asign_recursive_diccionary(partida.get("mapa"), mapa)
	_asign_recursive_diccionary(partida.get("dm"), dm)
	
	print("Partida cargada")

func eliminar_partida():
	var path := user_root + partida_rout
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func eliminar_debug_partida():
	var path := user_root + debug_partida_rout
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func sync_debug_to_current():
	debug["game_state"]["night"] = noche
	debug["game_state"]["combination"] = safe_code
	_asign_recursive_diccionary(inventario, debug["game_state"]["inventario"])
	_asign_recursive_diccionary(mapa, debug["game_state"]["mapa"])
	_asign_recursive_diccionary(dm, debug["game_state"]["dm"])

func guardar_progreso():
	if debug["prevent_save"]:
		return
	
	var progreso := {
		"custom_night": custom_night,
		"finales": finales,
	}
	
	var path := user_root + progreso_rout
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if file:
		file.store_string(JSON.stringify(progreso)) # "\t" = formato legible
		file.close()
		print("Progreso guardado")
	else:
		push_warning("Progreso fallido")

func leer_progreso():
	var path := user_root + progreso_rout
	if not FileAccess.file_exists(path):
		print("No existe el archivo de progreso.")
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	
	var progreso = JSON.parse_string(text)
	if progreso == null:
		push_warning("Error al leer JSON.")
		return
	
	custom_night = progreso.get("custom_night", custom_night)
	_asign_recursive_diccionary(progreso.get("finales"), finales)
	
	print("Progreso cargado")

func eliminar_progreso():
	var path := user_root + progreso_rout
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

#-misc

func _asign_recursive_diccionary(dick_origin: Dictionary, dick_destiny: Dictionary): # Los diccionarios ya funcionan como referencia en GDscrip
	
	for key in dick_origin:
		
		if not dick_destiny.has(key):
			continue # Si hay una configuración en el archivo que no está en el codigo, se ignora
		
		var origin_value = dick_origin[key]
		var destiny_value = dick_destiny[key]

		if typeof(origin_value) == TYPE_DICTIONARY and typeof(destiny_value) == TYPE_DICTIONARY:
			_asign_recursive_diccionary(origin_value, destiny_value)
		else:
			match typeof(destiny_value):
				TYPE_INT:
					dick_destiny[key] = int(origin_value)
				TYPE_FLOAT:
					dick_destiny[key] = float(origin_value)
				TYPE_BOOL:
					dick_destiny[key] = bool(origin_value)
				TYPE_STRING:
					dick_destiny[key] = str(origin_value)
				_:
					dick_destiny[key] = origin_value


#---Configuration---#


var config_default: Dictionary

var language := "En" 
var audio_language := "En"

var minigame_text_speed_mult := 1.0

var mouse_custom_op := 1.0
var mouse_custom_punt := "3"
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


#---Variables Progreso---#


var custom_night := false

var finales := {
	"mediocre": false,
	"party": false,
	"bad": false,
	"true": false,
	"good": false,
	"420": false,
}

#---Variables Partida---#

var noche := 1 # 1-6, 0 es custom night.

var safe_code := [2, 7, 3, 5, 3] # el codigo en orden de la caja
var location_key := 0


var inventario: Dictionary[String, bool] = {
	"key": false,
	"recorder": false,
	"screwdriver": false,
	"bateries": false,
	"pen": false,
	"files": false,
	"safe_usb_key": false,
	"dm_usb_key": false,
	"exe": false,
}


var mapa: Dictionary[String, bool] = {
	"door_office_open": false,
	"death_minigames": false,
	"safe_open": false,
	"safe_opened_by_animatronic": false,
	"computer_on": false,
	"computer_working": false,
	"computer_failed": false,
	"signed_in": false,
}


enum Estado { STANDBY, COMPLETADO, SALVADO }

var dm: Dictionary[String, Estado] = {
	"bonnie": Estado.STANDBY,
	"chica": Estado.STANDBY,
	"freddy": Estado.STANDBY,
	"foxy": Estado.STANDBY,
}

#---Funciones Partida---#


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

func create_new_game():
	eliminar_partida()
	for key in mapa: # reinicia todos los elementos
		mapa[key] = false
	for key in inventario: # no necesito hacer recursividad ni nada raro pues todos los elementos son bool
		inventario[key] = false
	for key in dm: # no necesito hacer recursividad ni nada raro pues todos los elementos son int
		dm[key] = Estado.STANDBY
	noche = 1
	safe_code = [0,0,0,0,0]
	guardar_partida()


#---Variables Noche---#


var custom_night_ai := [0, 0, 0, 0] # bonnie, chica, freddy, foxy

var timeless: bool
var night_speed := 5

var tick_count: int

var time_hour: int
var time_minute: int

var insanity: int # con 1000 te desmayas

var linterna_bateria := 100:
	get: return linterna_bateria
	set(valor): linterna_bateria = clamp(valor, 0.0, 100.0)

var linterna_bateria_show_anyways_because_i_dont_find_another_good_solution := false


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


var energia := { # swithces
	"General": true,
	"Luces": true,
	"Ventilacion": true,
	"Puertas": true,
	"Linterna": true,
	"Camaras": true,
	"Heater": false
}


#---Funciones Noche---#


func reset_night():
	killed_by = "none"
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
	act_animatronic_ai(time_hour)

func night_starts():
	
	if noche == 0:
		return
	
	if noche >= 4 and not inventario["key"]:
		location_key = randi_range(1,3)
	
	mapa["computer_failed"] = false
	if mapa["computer_working"]:
		set_energia_consumption("Especial", 1)

func get_night_info(animatronic: String, night: int, time: int):
	var row: int
	var column := 2 + (night - 1) * 6 + time
	const CSV_name: String = "Night_database.csv"
	
	if animatronic == "bonnie":
		row = 2
	elif animatronic == "chica":
		row = 3
	elif animatronic == "freddy":
		row = 4
	elif animatronic == "foxy":
		row = 5
	
	return get_csv_value_int(CSV_name, row, column)

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


func set_energia_consumption(nombre: String, valor: int): # En vez de dar el valor directamente, se usa esta función
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

func print_energia_consumption():
	var salida := "\n--- Estado de energía ---\n"
	for clave in energia_consumption.keys():
		salida += "%s: %s\n" % [clave, str(energia_consumption[clave])]
	print(salida)

func set_energia(nombre: String, valor: bool): # En vez de dar el valor directamente, se usa esta función
		
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


#---Señales Noche---#

signal Energy_Breakdown # Se manda cuando salta la luz
signal act_ai_state # Se manda cuando se actualiza la IA de los animatronicos. Normalmente cada hora
signal energia_actualizada # Se manda cuando cambias un switch

#---Variables Minigame---#

var m_entering := true

var just_death_min := "none" #none, kbonnie, kchica, kfreddy, kfoxy. sbonnie...

#---Funciones Minigame---#

func minigame_starts():
	
	if just_death_min == "none":
		leer_partida() # En esta funcion es donde se maneja el debug
	
	if debug["game_state"]["override"]: # esto es lo unico de debug que tengo que manejar aqui
		if debug["game_state"]["force_enter"]:
			m_entering = true
		elif debug["game_state"]["force_exit"]:
			m_entering = false
	
	if m_entering:
		
		if just_death_min == "none":
			mapa["safe_opened_by_animatronic"] = false
			mapa["door_office_open"] = false
			mapa["computer_on"] = false
			mapa["computer_working"] = false
			if noche == 5:
				randomize_safe_code()
		
		mapa["computer_failed"] = false # A partir de aqui se ejecuta siempre al entrar
	
	else:
		if mapa["door_office_open"] and not mapa["safe_open"]:
			mapa["safe_opened_by_animatronic"] = true


#---Debug---#

#-Variables

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
		"force_enter": false,
		"force_exit": false,
		"force_combination": false,
		"combination": [0,0,0,0,0],
		"mapa": mapa.duplicate(true),
		"inventario": inventario.duplicate(true),
		"dm": dm.duplicate(true),
	},
}

@onready var idle_debug := debug.duplicate(true)

#-Funciones

func reset_debug():
	debug = idle_debug.duplicate(true)
	leer_progreso()
	leer_partida()
	eliminar_debug_partida()


#---Ready---#

func _ready():
	
	eliminar_debug_partida() # De existir, elimina el archivo
	
	leer_progreso()
	
	leer_partida()
	
	guardar_configuration_default()
	
	leer_configuration()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventario"):
		print(Global.inventario)
		print(Global.mapa)
		print(Global.dm)
