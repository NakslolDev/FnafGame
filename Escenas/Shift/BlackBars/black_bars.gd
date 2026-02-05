extends Control

@export var label: RichTextLabel
@export var timer: Timer

var count := 0
var block_blink := false

func _ready():
	decide_text()
	timer.start(2)

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
	
	label.text = Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)

func _on_generic_timer_07_timeout() -> void:
	if count > 5 or block_blink:
		return
	label.visible = !label.visible
	count += 1
	timer.start(0.6)
