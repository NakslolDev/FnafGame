extends CamBase

@export var chica_sounds: Node
@export var foxy_sounds: Node
@export var safe_sounds: Node

@export var camaras_root: Node2D


var active: bool

func actualizar_cams():
	
	active = visible and camaras_root.activado
	
	act_combination()
	
	if Chica.position == "6" and not (Global.mapa["door_office_open"] and not (Global.mapa["safe_open"])):
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
	if active:
		safe_sounds.begin()
	else:
		safe_sounds.end()
