extends Node2D

var game_over: bool
var se_puede: bool
var on_cam_up_hitbox := false

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

func _on_area_2d_up_mouse_entered() -> void:
	if not Global.misc["Flick_cams"]: return
	if se_puede and not game_over and camaras.activado == false:
		toggle_cams()
		on_cam_up_hitbox = true

func _on_area_2d_up_mouse_exited() -> void:
	on_cam_up_hitbox = false

func _on_area_2d_down_mouse_entered() -> void:
	if not Global.misc["Flick_cams"]: return
	if se_puede and not game_over and on_cam_up_hitbox == false and camaras.activado == true:
		toggle_cams()


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

func _on_oficina_girando_estado(girando: int) -> void:
	if girando == 0:
		se_puede = true
	else:
		se_puede = false


func _on_main_game_on_tick_stop() -> void:
	game_over = true
