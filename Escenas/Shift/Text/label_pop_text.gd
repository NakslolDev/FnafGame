extends RichTextLabel

@export var pop_text: Control
@export var timer_per_letter: Timer
@export var audio_stream_player: AudioStreamPlayer

const NO_PAUSE := 0.05
const SHORT_PAUSE := 0.2
const LONG_PAUSE := 0.5

var _text: String
var letter: int
var printing := false
var id_num := 0

var slow: bool
var unskipable: bool
var silent: bool

var skiped := false

func start_print(id: String):
	_text = get_id_num(id)
	letter = 0
	if skiped:
		letter = 1
		skiped = false
	
	slow = find_in_txt(_text, "slow")
	unskipable = find_in_txt(_text, "unskipable")
	silent = find_in_txt(_text, "silent")
	
	printing_letters()
	#print("text_lenght: ", _text.length())

func _on_timer_per_letter_timeout() -> void:
	letter += 1
	printing_letters()

func printing_letters():
	printing = true
	var old_text := _text
	var new_text: String
	
	while letter < old_text.length() and old_text[letter] == "[":
		var end_index = old_text.find("]", letter)
		if end_index == -1:
			break
		letter = end_index + 1
	
	new_text = old_text.substr(0, letter)
	
	sound(new_text)
	
	if find_opend(new_text, "abs_rainbow"):
		new_text += " [/abs_rainbow]"
	
	if pop_text.green_text:
		new_text += "[color=green]"
	else:
		new_text += "[color=black]"
	
	old_text = new_text + remove_tags(old_text.substr(letter, old_text.length() - letter))  # Deshabilita las etiquetas
	new_text += old_text.substr(letter, old_text.length() - letter)
	
	text = new_text
	
	if letter >= _text.length():
		printing = false
		
		if find_in_txt(new_text, "skip"):
			pop_text.show_text()
			skiped = true
		
		return
	
	
	var mult := 1.0/Global.minigame_text_speed_mult
	if slow:
		mult = 3
	if _text.substr(0, letter).ends_with("."):
		timer_per_letter.start(LONG_PAUSE*mult)
	elif _text.substr(0, letter).ends_with("?"):
		timer_per_letter.start(LONG_PAUSE*mult)
	elif _text.substr(0, letter).ends_with("!"):
		timer_per_letter.start(LONG_PAUSE*mult)
	elif _text.substr(0, letter).ends_with(":"):
		timer_per_letter.start(LONG_PAUSE*mult)
	elif _text.substr(0, letter).ends_with(","):
		timer_per_letter.start(SHORT_PAUSE*mult)
	else:
		if pop_text.debuging_text and not Input.is_action_pressed("Click"):
			timer_per_letter.start(1*mult)
		else:
			timer_per_letter.start(NO_PAUSE*mult)

func remove_tags(txt: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(txt, "", true)

func end_timer():
	timer_per_letter.stop()
	_on_timer_per_letter_timeout()

func find_in_txt(txt:String, label: String):
	if txt.find("[" + label + "]") == -1:
		return false
	else:
		return true

func find_opend(txt:String, label: String):
	var from := 0
	while true: # tiene que encontrar si hay sueltos. Elimina los que están cerrados
		if txt.find("[" + label + "]", from) == -1:
			return false
		if txt.find("[/" + label + "]", from) == -1:
			return true
		from = txt.find("[/" + label + "]", from) + ("[/" + label + "]").length()


func sound(space: String):
	if _text == "" or silent:
		return
	if space.ends_with(" ") or space.ends_with("]") or letter == 0:
		return
	if slow:
		audio_stream_player.pitch_scale = randf_range(0.4, 0.6)
	else:
		audio_stream_player.pitch_scale = randf_range(0.7, 0.9)
	audio_stream_player.play()


func get_id_num(id_string: String):
	id_string += "_" + str(id_num).pad_zeros(2)
	
	if id_num > 1 and Global.get_csv_value_id(Global.text_CSV_name, id_string, Global.language).ends_with("(id non existant)"):
		pop_text.exit()
		return ""
	
	return Global.get_csv_value_id(Global.text_CSV_name, id_string, Global.language)


##Normas de uso
#Para empezar, las ids de los textos tienen que estar en orden terminando en _01, _02, etc...
#En el texto, cualquier etiqueta ha de estar ordenada. No puedes cerrar una etiqueta y despues abrirla, pues se rompe
#Etiquetas de cosas globales del texto, como unskipable, pueden estar abiertas en cualquier parte del texto. Por convenio mio, al final todas las de estados globales
#Las etiquetas de efectos no globales que duran todo el texto no hace falta cerrarlas
#En el texto no pueden ni haber corchetes (puede cambiar, pero de momento no es necesario), ni corchetes dentro de una etiqueta
