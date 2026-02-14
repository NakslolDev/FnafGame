extends CamBase

@export var chica_sounds: Node
@export var foxy_sounds: Node
@export var safe_sounds: Node

func actualizar_cams():
	act_combination()
	
	if Chica.position == "6" and not (Global.noche == 5 and Global.mapa["door_office_open"] and not (Global.mapa["safe_open"])):
		chica_sounds.active = true
		chica_sounds.act_playing()
	else:
		chica_sounds.active = false
	
	if Foxy.room == "almacen":
		foxy_sounds.active = true
		foxy_sounds.act_playing()
	else:
		foxy_sounds.active = false


func act_combination():
	if visible:
		safe_sounds.begin()
	else:
		safe_sounds.end()
