extends Node2D

var game_over: bool = false
var se_puede: bool = true
var up_cams_block := false
var down_cams_block := false

@export var root: Node2D
@export var camaras: Node2D
@export var up_cams: Sprite2D


func _ready():
	game_over = false
	camaras.activado = false
	root.camaras_activadas = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Space") and se_puede and not game_over:
		toggle_cams()

func _on_area_2d_down_mouse_entered() -> void:
	if not Global.misc["Flick_cams"]: return
	if camaras.activado and se_puede and not game_over and not up_cams_block:
		toggle_cams()
		down_cams_block = true

func _on_area_2d_up_mouse_entered() -> void:
	if not Global.misc["Flick_cams"]: return
	if not camaras.activado and se_puede and not game_over and not down_cams_block:
		toggle_cams()
		up_cams_block = true

func _on_area_2d_up_mouse_exited() -> void:
	up_cams_block = false
	down_cams_block = false

signal cams_toggled

func toggle_cams():
	if game_over:
		return
	
	if root.camaras_activadas:
		camaras.activado = false
		root.camaras_activadas = false
		Global.set_energia_consumption("Camaras", 0)
		Global.set_energia_consumption("Cam_lights", 0)
	else:
		root.stop_alucinations()
		camaras.activado = true
		root.camaras_activadas = true
		if Global.energia["Camaras"] == true:
			Global.set_energia_consumption("Camaras", 1)
	up_cams.act(root.camaras_activadas)
	cams_toggled.emit()

func _on_oficina_girando_estado(girando: int) -> void:
	if girando == 0:
		se_puede = true
	else:
		se_puede = false


func _on_main_game_on_tick_stop() -> void:
	game_over = true
