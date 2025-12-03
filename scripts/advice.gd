extends Label

func act_advice(type: int):
	text = get_advice_string(type)

func get_advice_string(type: int):
	var id: String
	
	if type == 0:
		id = "Adv_g_0" + str(randi_range(1, 5))
	elif type == 1:
		id = "Adv_b_0" + str(randi_range(1, 2))
	elif type == 2:
		id = "Adv_c_0" + str(randi_range(1, 4))
	elif type == 3:
		id = "Adv_fr_0" + str(randi_range(1, 3))
	elif type == 4:
		id = "Adv_fx_0" + str(randi_range(1, 5))
	
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)

func get_csv_value(row_id: String, lang_code: String) -> String:
	
	push_error("old function get_csv_value. Use Global function instead")
	
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
