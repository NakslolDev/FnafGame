extends Control

var count := 0
var block_blink := false

func _ready():
	decide_text()
	$Generic_timer_07.start(2)

func decide_text():
	var id: String
	if Global.m_entering:
		id = "bartxt_enter"
	else:
		if Global.inventario["exe"]:
			id = "bartxt_exe"
		elif Global.mapa["computer_working"]:
			id = "bartxt_compu"
		else:
			id = "bartxt_exit"
	
	$RichTextLabel.text = get_csv_value(id, Global.language)

func _on_generic_timer_07_timeout() -> void:
	if count > 5 or block_blink:
		return
	$RichTextLabel.visible = !$RichTextLabel.visible
	count += 1
	$Generic_timer_07.start(0.6)

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
