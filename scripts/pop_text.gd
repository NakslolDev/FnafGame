extends Control

@export var debuging_text := false
var id_String: String
var end_in: int
var on := false

func pop_up(id: String, read: bool):
	if end_in != 0 and read:
		$Control/Label_pop_text.id_num = end_in
	id_String = id
	$Timer.start()
	show_text(read)


func show_text(read := false):
	if end_in != 0 and read == false and $Control/Label_pop_text.id_num == end_in:
		exit()
		return
	$Control/Label_pop_text.id_num += 1
	$Control/Label_pop_text.start_print(id_String)

func _input(event: InputEvent) -> void:
	if $Control/Label_pop_text.unskipable:
		return
	if on and event.is_action_pressed("interact"):
		if $Control/Label_pop_text.printing:
			$Control/Label_pop_text.letter = $Control/Label_pop_text._text.length() - 1 # ese -1 es porque si no se come la etiqueta y hace que la ultima palabra sea mas larga y que salte de linea
			$Control/Label_pop_text.end_timer()
		else:
			show_text()

func _on_timer_timeout() -> void:
	on = true

func exit():
	on = false
	$Control/Label_pop_text.id_num = 0
	$"../.."._on_finished_text()
