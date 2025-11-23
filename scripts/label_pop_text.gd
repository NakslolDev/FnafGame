extends RichTextLabel

var _text: String
var letter: int
var printing := false
var id_num := 0

var slow := false
var unskipable := false

var skiped := false

func start_print(id: String):
	_text = get_id_num(id)
	letter = 0
	if skiped:
		letter = 1
		skiped = false
	printing_letters()

func _on_timer_per_letter_timeout() -> void:
	letter += 1
	printing_letters()

func printing_letters():
	printing = true
	var old_text := _text
	var new_text: String
	
	if old_text.substr(0, letter).ends_with("["):
		var end_index = old_text.substr(letter, old_text.length()).find("]")  # busca la primera aparición de "]"
		if end_index != -1:
			# saltar hasta justo después del cierre. Recordar que end_index cuenta desde letter, ya que es desde donde empieza a buscar. No queremos que en el tercer [ se cierre con el primer ]
			letter += end_index + 1
	
	
	new_text = old_text.substr(0, letter)
	
	if find_opend(new_text, "slow"):
		slow = true
	else:
		slow = false
	if find_opend(new_text, "unskipable"):
		unskipable = true
	else:
		unskipable = false
	
	
	sound(new_text)
	
	if find_opend(new_text, "abs_rainbow"):
		new_text += " [/abs_rainbow]"
	new_text += "[color=black]"
	
	old_text = new_text + old_text.substr(letter, old_text.length() - letter).replace("[", "")  # Deshabilita las etiquetas
	new_text += old_text.substr(letter, old_text.length() - letter)
	
	text = new_text
	
	if letter >= _text.length():
		printing = false
		return
	
	if find_opend(new_text, "skip"):
		$"../..".show_text()
		skiped = true
		return
	
	var mult := 1.0/Global.minigame_text_speed_mult
	if slow:
		mult = 3
	if _text.substr(0, letter).ends_with("."):
		$Timer_per_letter.start(0.5*mult)
	elif _text.substr(0, letter).ends_with("?"):
		$Timer_per_letter.start(0.5*mult)
	elif _text.substr(0, letter).ends_with("!"):
		$Timer_per_letter.start(0.5*mult)
	elif _text.substr(0, letter).ends_with(":"):
		$Timer_per_letter.start(0.5*mult)
	elif _text.substr(0, letter).ends_with(","):
		$Timer_per_letter.start(0.2*mult)
	else:
		if $"../..".debuging_text and not Input.is_action_pressed("Click"):
			$Timer_per_letter.start(1*mult)
		else:
			$Timer_per_letter.start(0.05*mult)

func end_timer():
	$Timer_per_letter.stop()
	_on_timer_per_letter_timeout()

func find_opend(txt:String, label: String):
	var from := 0
	while true: # tiene que encontrar si hay sueltos. Elimina los que están cerrados
		if txt.find("[" + label + "]", from) == -1:
			return false
		if txt.find("[/" + label + "]", from) == -1:
			return true
		from = txt.find("[/" + label + "]", from) + ("[/" + label + "]").length()

func sound(space: String):
	if space.ends_with(" ") or space.ends_with("]") or letter == 0:
		return
	if slow:
		$"../../AudioStreamPlayer".pitch_scale = randf_range(0.4, 0.6)
	else:
		$"../../AudioStreamPlayer".pitch_scale = randf_range(0.7, 0.9)
	$"../../AudioStreamPlayer".play()

func get_id_num(id_string: String):
	
	id_string += "_0" + str(id_num)
	
	if id_num > 1 and get_csv_value(id_string, Global.language).ends_with("(id non existant)"):
		$"../..".exit()
		return ""
	
	return get_csv_value(id_string, Global.language)

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
