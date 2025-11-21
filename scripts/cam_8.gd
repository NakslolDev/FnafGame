extends Node2D

var bonnie_al := false
var foxy_al := false

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Bonnie.position == "5" or bonnie_al:
		$Bonnie8.modulate.a = 1.0
	else:
		$Bonnie8.modulate.a = 0.0
	
	if (Foxy.room == "closet" and Foxy.position == 1) or foxy_al:
		$Foxy8.modulate.a = 1.0
	else:
		$Foxy8.modulate.a = 0.0


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 8 or local_to == 8 or local_extra == 8:
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	bonnie_al = false
	foxy_al = false
	if $"../../..".memoria[7] == false:
		actualizar_cams()
		return
	var who := randi_range(1, 2)
	if who == 1:
		bonnie_al = true
	else:
		foxy_al = true
	actualizar_cams()
