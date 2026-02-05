extends Node2D

var chica_al := false
var freddy_al := false
var foxy_al := false

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Chica.position == "2" or chica_al:
		$Chica4.modulate.a = 1.0
	else:
		$Chica4.modulate.a = 0.0
	
	if (Freddy.path == 2 and Freddy.position == "2") or freddy_al:
		$Freddy4.modulate.a = 1.0
	else:
		$Freddy4.modulate.a = 0.0
	
	if (Foxy.room == "entrance" and Foxy.position == 1) or foxy_al:
		$Foxy4.modulate.a = 1.0
	else:
		$Foxy4.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 4 or local_to == 4 or local_extra == 4:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	chica_al = false
	freddy_al = false
	foxy_al = false
	if $"../../..".memoria[3] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 3)
	if who == 1:
		chica_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = true
	actualizar_cams()
