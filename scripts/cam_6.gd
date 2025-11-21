extends Node2D

func _ready():
	actualizar_cams()

func actualizar_cams():
	if Chica.position == "6" and not (Global.noche == 5 and Global.mapa["door_office_open"] and not (Global.mapa["safe_open"])):
		$Chica_sounds.active = true
		$Chica_sounds.act_playing()
	else:
		$Chica_sounds.active = false
	
	if Foxy.room == "almacen":
		$Foxy_sounds.active = true
		$Foxy_sounds.act_playing()
	else:
		$Foxy_sounds.active = false

func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, al: bool) -> void:
	if freddy or local_from == 6 or local_to == 6 or local_extra == 6:
		act_combination()
		actualizar_cams()
		if al == true:
			_on_camaras_alucinations()


func _on_camaras_alucinations() -> void:
	pass # De momento nada


func _on_minimapa_botones_cam_act() -> void:
	act_combination()

func act_combination():
	if $"../../..".camara_activa == 6 and $"../../..".activado:
		$Safe_sounds.begin()
	else:
		$Safe_sounds.end()
