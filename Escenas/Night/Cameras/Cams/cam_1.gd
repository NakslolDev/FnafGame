extends Node2D

var bonnie_al := false
var chica_al := false
var freddy_al := false

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "S" or bonnie_al:
		$BonnieS.modulate.a = 1.0
	else:
		$BonnieS.modulate.a = 0.0
	
	if Chica.position == "S" or chica_al:
		$ChicaS.modulate.a = 1.0
	else:
		$ChicaS.modulate.a = 0.0
	
	if Freddy.position == "S" or freddy_al:
		$FreddyS.modulate.a = 1.0
	else:
		$FreddyS.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 1 or local_to == 1 or local_extra == 1:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	bonnie_al = false
	chica_al = false
	freddy_al = false
	if $"../../..".memoria[0] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 3)
	if who == 1:
		bonnie_al = true
	elif who == 2:
		chica_al = true
	else:
		freddy_al = true
	actualizar_cams()
