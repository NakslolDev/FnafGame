extends Control

@export var debug := false

func _input(event):
	if $Debug_panel.visible:
		return
	if event.is_action_pressed("Esc"):
		salir()

func salir(guardar := true):
	Global.escena_previa = "Opciones"
	if guardar:
		Global.guardar_configuration()
	else:
		Global.leer_configuration()
	get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn")



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


func _on_save_pressed() -> void:
	Global.guardar_configuration()

func _on_undo_pressed() -> void:
	Global.leer_configuration()
	get_tree().change_scene_to_file("res://escenas/Opciones.tscn")

func _on_reset_pressed() -> void:
	Global.reset_configuration()
	get_tree().change_scene_to_file("res://escenas/Opciones.tscn")

func _on_save_exit_pressed() -> void:
	salir()

func _on_exit_pressed() -> void:
	salir(false)
