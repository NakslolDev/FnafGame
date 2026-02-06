extends VBoxContainer

@export var id_time: String
@export var id_speed: String
@onready var root_node = get_node("/root/Opciones")

var active: bool
var UI := "Energia"

func _ready():
	active = Global.fade[UI]["Active"]
	act_active_state()
	set_value("Time")
	set_value("Speed")
	actualizar_speed()
	actualizar_time()

func set_value(who:String):
	var value = Global.fade[UI][who]
	if value <= 10:
		get_node(who + "_Slider").value = value
	else:
		get_node(who + "_Slider").value = (value - 10) / 10 + 10

func actualizar_time():
	if Global.fade[UI]["Time"] < 10:
		$Fade_Time.text = " " + root_node.get_text(id_time) + " " + str(Global.fade[UI]["Time"])
	else:
		var float_to_int: int = Global.fade[UI]["Time"]
		$Fade_Time.text = " " + root_node.get_text(id_time) + " " + str(float_to_int)

func actualizar_speed():
	if Global.fade[UI]["Speed"] < 10:
		$Fade_Speed.text = " " + root_node.get_text(id_speed) + " " + str(Global.fade[UI]["Speed"])
	else:
		var float_to_int: int = Global.fade[UI]["Speed"]
		$Fade_Speed.text = " " + root_node.get_text(id_speed) + " " + str(float_to_int)

func _on_button_ui_type_pressed() -> void:
	if UI == "Energia":
		UI = "Linterna"
	else:
		UI = "Energia"
	
	if active != Global.fade[UI]["Active"]:
		_on_button_fade_out_pressed()
	_ready()

func act_active_state():
	$"../Button_Fade_Out".active = Global.fade[UI]["Active"]
	$"../Button_Fade_Out"._ready()
	$Time_Slider.editable = active
	$Speed_Slider.editable = active
	if active:
		$".".modulate = Color(1, 1, 1, 1)
	else:
		$".".modulate = Color(1, 1, 1, 0.2)

func _on_button_fade_out_pressed() -> void:
	active = !active
	Global.fade[UI]["Active"] = active
	act_active_state()

func _on_time_slider_value_changed(value: float) -> void:
	if value <= 10:
		Global.fade[UI]["Time"] = value
	else:
		Global.fade[UI]["Time"] = (value - 10) * 10 + 10
	actualizar_time()

func _on_speed_slider_value_changed(value: float) -> void:
	if value <= 10:
		Global.fade[UI]["Speed"] = value
	else:
		Global.fade[UI]["Speed"] = (value - 10) * 10 + 10
	actualizar_speed()
