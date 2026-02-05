extends Node2D

var chica_al := false
var freddy_al := false
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Chica.position == "PD" or chica_al:
		$Chica11b.modulate.a = 1.0
	else:
		$Chica11b.modulate.a = 0.0
	
	if (Freddy.path == 2 and Freddy.position == "PD") or freddy_al:
		$Freddy11b.modulate.a = 1.0
	else:
		$Freddy11b.modulate.a = 0.0
	
	if (Foxy.room == "rhall" and Foxy.position == 2) or foxy_al == 1:
		$Foxy11b_1.modulate.a = 1.0
		$Foxy11b_2.modulate.a = 0.0
	elif (Foxy.room == "Duc8" and Foxy.position == 6) or foxy_al == 2:
		$Foxy11b_1.modulate.a = 0.0
		$Foxy11b_2.modulate.a = 1.0
	else:
		$Foxy11b_1.modulate.a = 0.0
		$Foxy11b_2.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 13 or local_to == 13 or local_extra == 13:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	chica_al = false
	freddy_al = false
	foxy_al = 0
	if $"../../..".memoria[12] == false:
		actualizar_cams()
		return
		
	var who := randi_range(1, 3) # de momento admito varios
	 
	if who == 1:
		chica_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = randi_range(1, 2)
	actualizar_cams()
