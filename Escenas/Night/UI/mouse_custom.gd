extends Node2D

@export var menu := false
@export var cams := false
@export_range(0.0, 1.0, 0.01)
var opacidad: float = 1.0
@export_enum("1", "2", "3", "4", "5")
var puntero: String = "1"
var override_alpha := false

func _ready():
	
	if Global.mouse_custom_op < 0.0:
		Global.mouse_custom_op = opacidad
	else:
		opacidad = Global.mouse_custom_op
	if Global.mouse_custom_punt == "0":
		Global.mouse_custom_punt = puntero
	else:
		puntero = Global.mouse_custom_punt
	
	$PunteroCustomCam.modulate.a = 0.0
	$PunteroCustomCam2.modulate.a = 0.0
	$PunteroCustomCam3.modulate.a = 0.0
	$PunteroCustomCam4.modulate.a = 0.0
	$PunteroCustomCam5.modulate.a = 0.0
	$PunteroCustom.modulate.a = 0.0
	$PunteroCustom2.modulate.a = 0.0
	$PunteroCustom3.modulate.a = 0.0
	$PunteroCustom4.modulate.a = 0.0
	$PunteroCustom5.modulate.a = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if Global.mouse_cam_see and cams:
		if puntero == "1":
			$PunteroCustomCam.modulate.a = 1.0
		if puntero == "2":
			$PunteroCustomCam2.modulate.a = 1.0
		if puntero == "3":
			$PunteroCustomCam3.modulate.a = 1.0
		if puntero == "4":
			$PunteroCustomCam4.modulate.a = 1.0
		if puntero == "5":
			$PunteroCustomCam5.modulate.a = 1.0
	else:
		if puntero == "1":
			$PunteroCustom.modulate.a = 1.0
		if puntero == "2":
			$PunteroCustom2.modulate.a = 1.0
		if puntero == "3":
			$PunteroCustom3.modulate.a = 1.0
		if puntero == "4":
			$PunteroCustom4.modulate.a = 1.0
		if puntero == "5":
			$PunteroCustom5.modulate.a = 1.0

func _process(_delta):
	if not override_alpha:
		if menu and Global.mouse_custom_op < 0.15:
			modulate.a = 1.0
		else:
			modulate.a = Global.mouse_custom_op
	global_position = get_global_mouse_position()

func _on_button_pressed() -> void:
	_ready()
