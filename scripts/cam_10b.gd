extends Node2D

var bonnie_al := false
var freddy_al := false
var foxy_al := 0

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "PI" or bonnie_al:
		$Bonnie10b.modulate.a = 1.0
	else:
		$Bonnie10b.modulate.a = 0.0
	
	if (Freddy.path == 1 and Freddy.position == "PI") or freddy_al:
		$Freddy10b.modulate.a = 1.0
	else:
		$Freddy10b.modulate.a = 0.0
	
	if (Foxy.room == "lhall" and Foxy.position == 2) or foxy_al == 1:
		$Foxy10b_1.modulate.a = 1.0
		$Foxy10b_2.modulate.a = 0.0
	elif (Foxy.room == "Duc8" and Foxy.position == 2) or foxy_al == 2:
		$Foxy10b_1.modulate.a = 0.0
		$Foxy10b_2.modulate.a = 1.0
	else:
		$Foxy10b_1.modulate.a = 0.0
		$Foxy10b_2.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 11 or local_to == 11 or local_extra == 11:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	bonnie_al = false
	freddy_al = false
	foxy_al = 0
	if $"../../..".memoria[10] == false:
		actualizar_cams()
		return
		
	var who := randi_range(1, 3) # de momento admito varios
	 
	if who == 1:
		bonnie_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = randi_range(1, 2)
	actualizar_cams()
