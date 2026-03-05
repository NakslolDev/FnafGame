extends Control

@export var debuging_text := false
@export var green_text := false

var id_String: String
var end_in: Array[int]
var on := false
var local_read: int

@export var txt_label: RichTextLabel
@export var timer: Timer
@export var minigame: Node

func pop_up(id: String, read: int):
	local_read = read
	if end_in != [] and local_read:
		txt_label.id_num = end_in[local_read-1] #empieza del anterior valor
	id_String = id
	timer.start()
	show_text()

func show_text():
	print("(PT)  Read: ", local_read, "  End in: ", end_in, "  id_num: ", txt_label.id_num, "  ID: ", id_String)
	if not (end_in.size() <= local_read) and txt_label.id_num == end_in[local_read]:
		exit()
		return
	txt_label.id_num += 1
	txt_label.start_print(id_String)

func _input(event: InputEvent) -> void:
	if txt_label.unskipable and txt_label.printing:
		return
	if on and event.is_action_pressed("interact"):
		if txt_label.printing:
			txt_label.letter = txt_label._text.length() - 1 # ese -1 es porque si no se come la etiqueta y hace que la ultima palabra sea mas larga y que salte de linea
			txt_label.end_timer()
		else:
			show_text()

func _on_timer_timeout() -> void:
	on = true

func exit():
	on = false
	timer.stop()
	txt_label.id_num = 0
	minigame._on_finished_text()
