extends Node2D

@export var energia := 0:
	get = get_energia, set = set_energia
var _energia := 0
var onready_var := false
var obscure := false
@export var obscure_time_animation := 2.0
@export var obscure_time := 3.0

func get_energia():
	return _energia

func set_energia(value: int):
	obscure = false
	if obscure_time > 0:
		$Timer_obscure.start(obscure_time)
	else:
		obscure = true
	if onready_var == false:
		return
	_energia = value
	if energia == 0:
		desactivar_parte("3")
		desactivar_parte("2")
		desactivar_parte("1")
	elif energia == 1:
		desactivar_parte("3")
		desactivar_parte("2")
		activar_parte("1")
	elif energia == 2:
		desactivar_parte("3")
		activar_parte("2")
		activar_parte("1")
	elif energia == 3:
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
	actualizar_skin()

func _ready():
	
	obscure_time = Global.fade["Energia"]["Time"]
	obscure_time_animation = Global.fade["Energia"]["Speed"]
	
	obscure = false
	if obscure_time > 0:
		$Timer_obscure.wait_time = obscure_time
		$Timer_obscure.start()
	else:
		obscure = true
	onready_var = true
	actualizar_skin()

func _process(delta):
	if energia != Global.energia_consumption["Total"]:
		energia = Global.energia_consumption["Total"]
	if obscure == true and Global.fade["Energia"]["Active"]:
		modulate.a -= delta / obscure_time_animation
	visible = Global.energia["General"] # al principio era el general, pero he decidido cambiarlo a las luces

func actualizar_skin():
	modulate.a = Global.energia_skin["alpha_general"]
	$Base.modulate.a = Global.energia_skin["alpha_base"]

	for nombre_paleta in Global.energia_skin["partes"].keys():
		var paleta_node = get_node_or_null(nombre_paleta)
		if paleta_node == null:
			continue

		var alguna_visible = false

		for parte_id in Global.energia_skin["partes"][nombre_paleta].keys():
			var data = Global.energia_skin["partes"][nombre_paleta][parte_id]
			var parte_node = paleta_node.get_node_or_null(parte_id)
			if parte_node == null:
				continue

			parte_node.visible = data["visible"]
			if data["visible"]:
				parte_node.modulate.a = data["alpha"]
				if data["alpha"] > 0.0:
					alguna_visible = true
		
		paleta_node.visible = alguna_visible


func desactivar_parte(parte_id: String):
	for nombre_paleta in Global.energia_skin["partes"].keys():
		if parte_id in Global.energia_skin["partes"][nombre_paleta]:
			Global.energia_skin["partes"][nombre_paleta][parte_id]["visible"] = false
	actualizar_skin()

func activar_parte(parte_id: String):
	for nombre_paleta in Global.energia_skin["partes"].keys():
		if parte_id in Global.energia_skin["partes"][nombre_paleta]:
			Global.energia_skin["partes"][nombre_paleta][parte_id]["visible"] = true
	actualizar_skin()


func _on_timer_timeout() -> void:
	obscure = true
