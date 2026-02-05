extends Node2D

var bonnie_al := false
var freddy_al := false
var foxy_al := false

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "4" or bonnie_al:
		$Bonnie10a.modulate.a = 1.0
	else:
		$Bonnie10a.modulate.a = 0.0
	
	if (Freddy.path == 1 and Freddy.position == "3") or freddy_al:
		$Freddy10a.modulate.a = 1.0
	else:
		$Freddy10a.modulate.a = 0.0
	
	if (Foxy.room == "lhall" and Foxy.position == 1) or foxy_al:
		$Foxy10a.modulate.a = 1.0
	else:
		$Foxy10a.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 10 or local_to == 10 or local_extra == 10:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	bonnie_al = false
	freddy_al = false
	foxy_al = false
	if $"../../..".memoria[9] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 3)
	if who == 1:
		bonnie_al = true
	elif who == 2:
		freddy_al = true
	else:
		foxy_al = true
	actualizar_cams()
