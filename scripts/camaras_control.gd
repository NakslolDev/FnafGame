extends Node2D

var game_over: bool
var se_puede: bool
var on_cam_up_hitbox := false

func _ready():
	game_over = false
	$Camaras.activado = false
	$"..".camaras_activadas = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Space") and se_puede and not game_over:
		toggle_cams()

func _on_area_2d_up_mouse_entered() -> void:
	if se_puede and not game_over and $Camaras.activado == false:
		toggle_cams()
		on_cam_up_hitbox = true

func _on_area_2d_up_mouse_exited() -> void:
	on_cam_up_hitbox = false

func _on_area_2d_down_mouse_entered() -> void:
	if se_puede and not game_over and on_cam_up_hitbox == false and $Camaras.activado == true:
		toggle_cams()


func toggle_cams():
	if $"..".camaras_activadas:
		$Camaras.activado = false
		$"..".camaras_activadas = false
		Global.set_energia_consumption("Camaras", 0)
		Global.set_energia_consumption("Cam_lights", 0)
	else:
		$"..".stop_alucinations()
		$Camaras.activado = true
		$"..".camaras_activadas = true
		if Global.energia["Camaras"] == true:
			Global.set_energia_consumption("Camaras", 1)
	$"../True_No_Shader/UpCams".act($"..".camaras_activadas)

func _on_oficina_girando_estado(girando: int) -> void:
	if girando == 0:
		se_puede = true
	else:
		se_puede = false
