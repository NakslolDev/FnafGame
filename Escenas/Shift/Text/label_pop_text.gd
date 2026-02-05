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
	#print("text_lenght: ", _text.length())

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
		printing = false
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
	if _text == "":
		return
	if space.ends_with(" ") or space.ends_with("]") or letter == 0:
		return
	if slow:
		$"../../AudioStreamPlayer".pitch_scale = randf_range(0.4, 0.6)
	else:
		$"../../AudioStreamPlayer".pitch_scale = randf_range(0.7, 0.9)
	$"../../AudioStreamPlayer".play()

func get_id_num(id_string: String):
	
	if id_num <= 9:
		id_string += "_0" + str(id_num)
	else:
		id_string += "_" + str(id_num)
	
	if id_num > 1 and Global.get_csv_value_id(Global.text_CSV_name, id_string, Global.language).ends_with("(id non existant)"):
		$"../..".exit()
		return ""
	
	return Global.get_csv_value_id(Global.text_CSV_name, id_string, Global.language)
