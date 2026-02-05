extends Node2D

var bonnie_al := 0
var freddy_al := 0
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "0" or bonnie_al == 1:
		$Bonnie2_3.modulate.a = 0.0
		$Bonnie2_2.modulate.a = 0.0
		$Bonnie2_1.modulate.a = 1.0
	elif Bonnie.position == "1" or bonnie_al == 2:
		$Bonnie2_3.modulate.a = 0.0
		$Bonnie2_2.modulate.a = 1.0
		$Bonnie2_1.modulate.a = 0.0
	elif Bonnie.position == "2" or bonnie_al == 3:
		$Bonnie2_3.modulate.a = 1.0
		$Bonnie2_2.modulate.a = 0.0
		$Bonnie2_1.modulate.a = 0.0
	else:
		$Bonnie2_3.modulate.a = 0.0
		$Bonnie2_2.modulate.a = 0.0
		$Bonnie2_1.modulate.a = 0.0
	
	if Freddy.position == "0" or freddy_al == 1:
		$Freddy2_1.modulate.a = 1.0
		$Freddy2_2.modulate.a = 0.0
	elif (Freddy.path == 1 and Freddy.position == "1") or freddy_al == 2:
		$Freddy2_1.modulate.a = 0.0
		$Freddy2_2.modulate.a = 1.0
	else:
		$Freddy2_1.modulate.a = 0.0
		$Freddy2_2.modulate.a = 0.0
	
	if (Foxy.room == "main" and Foxy.position == 1) or foxy_al == 1:
		$Foxy2_1.modulate.a = 1.0
		$Foxy2_2.modulate.a = 0.0
		$Foxy2_3.modulate.a = 0.0
	elif (Foxy.room == "main" and Foxy.position == 2) or foxy_al == 2:
		$Foxy2_1.modulate.a = 0.0
		$Foxy2_2.modulate.a = 1.0
		$Foxy2_3.modulate.a = 0.0
	elif (Foxy.room == "Duc3" and Foxy.position == 3) or foxy_al == 3:
		$Foxy2_1.modulate.a = 0.0
		$Foxy2_2.modulate.a = 0.0
		$Foxy2_3.modulate.a = 1.0
	else:
		$Foxy2_1.modulate.a = 0.0
		$Foxy2_2.modulate.a = 0.0
		$Foxy2_3.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 2 or local_to == 2 or local_extra == 2:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()

func _on_camaras_alucinations() -> void:
	bonnie_al = 0
	freddy_al = 0
	foxy_al = 0
	if $"../../..".memoria[1] == false:
		actualizar_cams()
		return
		
	var who := randi_range(1, 3) # de momento admito varios
	 
	if who == 1:
		bonnie_al = randi_range(1, 3)
	elif who == 2:
		freddy_al = randi_range(1, 2)
	else:
		foxy_al = randi_range(1, 3)
	actualizar_cams()
