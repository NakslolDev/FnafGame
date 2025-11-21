extends Node2D

var game_exist := false
var noche_menu := 1

@export var transicion := 3.0
var transicionando_out: bool
var transicionando_in: bool

func _ready():
	game_exist = FileAccess.file_exists("user://partida.json")
	if Global.debug["game_state"]["override"]:
		noche_menu = Global.debug["game_state"]["night"]
	elif Global.noche != -1:
		noche_menu = Global.noche
	if Global.escena_previa != "Opciones" and Global.escena_previa != "Custom_Night":
		transicionando_in = true
		$Transicion.modulate.a = 1.0
	else:
		$Transicion.modulate.a = 0.0
	Global.custom_night_ai = [0, 0, 0, 0]
	$Play_Buttons.act_selected()


func _process(delta):
	if transicionando_out:
		$Transicion.modulate.a += delta / transicion
		if $Transicion.modulate.a >= 1.0:
			$Transicion.modulate.a = 1.0
			transicionando_out = false
			begin_game()
	if transicionando_in:
		$Transicion.modulate.a -= delta / transicion
		if $Transicion.modulate.a <= 0.0:
			$Transicion.modulate.a = 0.0
			transicionando_in = false

func transition_to_play(): # como no hay ningun otro caso de transicion, no tengo que distinguir
	transicionando_in = false
	transicionando_out = true

func begin_game():
	Global.escena_previa = "Menu_Principal"
	Global.m_entering = true
	Global.minigame_starts()
	get_tree().change_scene_to_file("res://escenas/minigame.tscn")



func get_text(id: String):
	return get_csv_value(id, Global.language)

func get_csv_value(row_id: String, lang_code: String) -> String:
	var path := "res://Data/Text_Traducted.csv"
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("No se pudo abrir el archivo CSV: " + path)
		return "Something went wrong... (CSV not found)"
	
	# Leer la cabecera para encontrar el índice del idioma
	if file.eof_reached():
		return "Something went wrong... (empty CSV)"
	
	var header = file.get_csv_line()
	var col_index = header.find(lang_code)
	if col_index == -1:
		return "Something went wrong... (Language not found: " + lang_code + ")"
	
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
