extends Node2D

var chica_al := false
var freddy_al := false
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	
	if Chica.position == "5" or chica_al:
		$Chica9.modulate.a = 1.0
	else:
		$Chica9.modulate.a = 0.0
	
	if (Freddy.path == 0 and Freddy.position == "T2") or chica_al:
		$Freddy9.modulate.a = 1.0
	else:
		$Freddy9.modulate.a = 0.0
	
	$Foxy9_1.modulate.a = 0.0
	$Foxy9_2.modulate.a = 0.0
	$Foxy9_3.modulate.a = 0.0
	$Foxy9_4.modulate.a = 0.0
	$Foxy9_5.modulate.a = 0.0
	if (Foxy.room == "pas" and Foxy.position == 0) or foxy_al == 1:
		$Foxy9_1.modulate.a = 1.0
	if (Foxy.room == "pas" and Foxy.position == 1) or foxy_al == 2:
		$Foxy9_3.modulate.a = 1.0
	if (Foxy.room == "pas" and Foxy.position == 2) or foxy_al == 3:
		$Foxy9_2.modulate.a = 1.0
	if (Foxy.room == "pas" and Foxy.position == 3) or foxy_al == 4:
		$Foxy9_4.modulate.a = 1.0
	if (Foxy.room == "Duc5" and Foxy.position == 6) or foxy_al == 5:
		$Foxy9_5.modulate.a = 1.0

func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 9 or local_to == 9 or local_extra == 9:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	chica_al = false
	freddy_al = false
	foxy_al = 0
	if $"../../..".memoria[8] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 3)
	if who == 1:
		chica_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = randi_range(1, 5)
	actualizar_cams()
