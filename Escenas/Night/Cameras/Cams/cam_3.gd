extends Node2D

var chica_al := false
var freddy_al := 0
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Chica.position == "1" or chica_al:
		$Chica3_1.modulate.a = 1.0
	else:
		$Chica3_1.modulate.a = 0.0
	
	if Freddy.position == "T1" or freddy_al == 1:
		$Freddy3_1.modulate.a = 1.0
		$Freddy3_2.modulate.a = 0.0
	elif (Freddy.path == 2 and Freddy.position == "1") or freddy_al == 2:
		$Freddy3_1.modulate.a = 0.0
		$Freddy3_2.modulate.a = 1.0
	else:
		$Freddy3_1.modulate.a = 0.0
		$Freddy3_2.modulate.a = 0.0
	
	if (Foxy.room == "main" and Foxy.position == 3) or foxy_al == 1:
		$Foxy3_1.modulate.a = 0.0
		$Foxy3_2.modulate.a = 1.0
		$Foxy3_3.modulate.a = 0.0
	elif (Foxy.room == "main" and Foxy.position == 4) or foxy_al == 2:
		$Foxy3_1.modulate.a = 1.0
		$Foxy3_2.modulate.a = 0.0
		$Foxy3_3.modulate.a = 0.0
	elif (Foxy.room == "main" and Foxy.position == 5) or foxy_al == 3:
		$Foxy3_1.modulate.a = 0.0
		$Foxy3_2.modulate.a = 0.0
		$Foxy3_3.modulate.a = 1.0
	else:
		$Foxy3_1.modulate.a = 0.0
		$Foxy3_2.modulate.a = 0.0
		$Foxy3_3.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 3 or local_to == 3 or local_extra == 3:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	chica_al = false
	freddy_al = 0
	foxy_al = 0
	if $"../../..".memoria[2] == false:
		actualizar_cams()
		return
		
	var who := randi_range(1, 3) # de momento admito varios
	 
	if who == 1:
		chica_al = true
	elif who == 2:
		freddy_al = randi_range(1, 2)
	else:
		foxy_al = randi_range(1, 3)
	actualizar_cams()
