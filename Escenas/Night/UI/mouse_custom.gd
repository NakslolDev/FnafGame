extends Node2D

@export var menu := false
@export var cams := false
@export_range(0.0, 1.0, 0.01)
var opacidad: float = 1.0
@export_enum("1", "2", "3", "4", "5")
var puntero: String = "1"
var override_alpha := false

@export var mouse_hitbox: Area2D # usado para bloquear la linterna

@export var puntero_custom: Sprite2D
@export var puntero_custom_2: Sprite2D
@export var puntero_custom_3: Sprite2D
@export var puntero_custom_4: Sprite2D
@export var puntero_custom_5: Sprite2D
@export var puntero_custom_cam: Sprite2D
@export var puntero_custom_cam_2: Sprite2D
@export var puntero_custom_cam_3: Sprite2D
@export var puntero_custom_cam_4: Sprite2D
@export var puntero_custom_cam_5: Sprite2D


func _ready():
	
	if Global.mouse_custom_op < 0.0:
		Global.mouse_custom_op = opacidad
	else:
		opacidad = Global.mouse_custom_op
	if Global.mouse_custom_punt == "0":
		Global.mouse_custom_punt = puntero
	else:
		puntero = Global.mouse_custom_punt
	
	puntero_custom_cam.modulate.a = 0.0
	puntero_custom_cam_2.modulate.a = 0.0
	puntero_custom_cam_3.modulate.a = 0.0
	puntero_custom_cam_4.modulate.a = 0.0
	puntero_custom_cam_5.modulate.a = 0.0
	puntero_custom.modulate.a = 0.0
	puntero_custom_2.modulate.a = 0.0
	puntero_custom_3.modulate.a = 0.0
	puntero_custom_4.modulate.a = 0.0
	puntero_custom_5.modulate.a = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if Global.mouse_cam_see and cams:
		if puntero == "1":
			puntero_custom_cam.modulate.a = 1.0
		if puntero == "2":
			puntero_custom_cam_2.modulate.a = 1.0
		if puntero == "3":
			puntero_custom_cam_3.modulate.a = 1.0
		if puntero == "4":
			puntero_custom_cam_4.modulate.a = 1.0
		if puntero == "5":
			puntero_custom_cam_5.modulate.a = 1.0
	else:
		if puntero == "1":
			puntero_custom.modulate.a = 1.0
		if puntero == "2":
			puntero_custom_2.modulate.a = 1.0
		if puntero == "3":
			puntero_custom_3.modulate.a = 1.0
		if puntero == "4":
			puntero_custom_4.modulate.a = 1.0
		if puntero == "5":
			puntero_custom_5.modulate.a = 1.0

func _process(_delta):
	if not override_alpha:
		if menu and Global.mouse_custom_op < 0.15:
			modulate.a = 1.0
		else:
			modulate.a = Global.mouse_custom_op
	global_position = get_global_mouse_position()

func _on_button_pressed() -> void:
	_ready()
