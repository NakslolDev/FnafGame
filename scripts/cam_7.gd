extends Node2D

var bonnie_al := 0
var freddy_al := false
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "2" or bonnie_al == 1:
		$Bonnie7_1.modulate.a = 1.0
		$Bonnie7_2.modulate.a = 0.0
	elif Bonnie.position == "3" or bonnie_al == 2:
		$Bonnie7_1.modulate.a = 0.0
		$Bonnie7_2.modulate.a = 1.0
	else:
		$Bonnie7_1.modulate.a = 0.0
		$Bonnie7_2.modulate.a = 0.0
	
	if Freddy.path == 1 and Freddy.position == "2":
		$Freddy7.modulate.a = 1.0
	else:
		$Freddy7.modulate.a = 0.0
	
	$Foxy7_1.modulate.a = 0.0
	$Foxy7_2.modulate.a = 0.0
	$Foxy7_3.modulate.a = 0.0
	$Foxy7_4.modulate.a = 0.0
	$Foxy7_5.modulate.a = 0.0
	$Foxy7_6.modulate.a = 0.0
	if (Foxy.room == "arcade" and Foxy.position == 1) or foxy_al == 1:
		$Foxy7_1.modulate.a = 1.0
	if (Foxy.room == "arcade" and Foxy.position == 2) or foxy_al == 2:
		$Foxy7_2.modulate.a = 1.0
	if (Foxy.room == "arcade" and Foxy.position == 3) or foxy_al == 3:
		$Foxy7_3.modulate.a = 1.0
	if (Foxy.room == "arcade" and Foxy.position == 4) or foxy_al == 4:
		$Foxy7_6.modulate.a = 1.0
	if (Foxy.room == "Duc1" and Foxy.position == 3) or foxy_al == 5:
		$Foxy7_5.modulate.a = 1.0
	if (Foxy.room == "Duc3" and Foxy.position == 1) or foxy_al == 6:
		$Foxy7_4.modulate.a = 1.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 7 or local_to == 7 or local_extra == 7:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	bonnie_al = 0
	freddy_al = false
	foxy_al = 0
	if $"../../..".memoria[6] == false:
		actualizar_cams()
		return
		
	var who := randi_range(1, 3) # de momento admito varios
	 
	if who == 1:
		bonnie_al = randi_range(1, 2)
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = randi_range(1, 6)
	actualizar_cams()
