extends Node2D

var chica_al := false
var freddy_al := false
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Chica.position == "3" or chica_al:
		$Chica5.modulate.a = 1.0
	else:
		$Chica5.modulate.a = 0.0
	
	if Freddy.path == 2 and Freddy.position == "3" or freddy_al:
		$Freddy5.modulate.a = 1.0
	else:
		$Freddy5.modulate.a = 0.0
	
	if Foxy.room == "kitchen" and Foxy.position == 1 or foxy_al == 1:
		$Foxy5_1.modulate.a = 1.0
		$Foxy5_2.modulate.a = 0.0
	elif Foxy.room == "Duc4" and Foxy.position == 4 or foxy_al == 2:
		$Foxy5_1.modulate.a = 0.0
		$Foxy5_2.modulate.a = 1.0
	else:
		$Foxy5_1.modulate.a = 0.0
		$Foxy5_2.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 5 or local_to == 5 or local_extra == 5:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	chica_al = false
	freddy_al = false
	foxy_al = 0
	if $"../../..".memoria[4] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 3)
	if who == 1:
		chica_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = randi_range(1, 2)
	actualizar_cams()
