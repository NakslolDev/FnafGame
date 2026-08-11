extends Node2D

@export var energia := 0:
	get = get_energia, set = set_energia
var _energia := 0
var onready_var := false
var obscure := false
@export var obscure_time_animation := 2.0
@export var obscure_time := 3.0

@export var timer_obscure: Timer

@export var partes: Array[Node2D]

func get_energia():
	return _energia

func set_energia(value: int):
	obscure = false
	if obscure_time > 0:
		timer_obscure.start(obscure_time)
	else:
		obscure = true
	if onready_var == false:
		return
	_energia = value
	if energia == 0:
		desactivar_parte(3)
		desactivar_parte(2)
		desactivar_parte(1)
	elif energia == 1:
		desactivar_parte(3)
		desactivar_parte(2)
		activar_parte(1)
	elif energia == 2:
		desactivar_parte(3)
		activar_parte(2)
		activar_parte(1)
	elif energia == 3:
		activar_parte(3)
		activar_parte(2)
		activar_parte(1)
	actualizar_skin()

func _ready():
	
	obscure_time = Global.fade["Energia"]["Time"]
	obscure_time_animation = Global.fade["Energia"]["Speed"]
	
	obscure = false
	if obscure_time > 0:
		timer_obscure.wait_time = obscure_time
		timer_obscure.start()
	else:
		obscure = true
	onready_var = true
	actualizar_skin()

func _process(delta):
	if tick_stop: return
	if energia != Global.energia_consumption["Total"]:
		energia = Global.energia_consumption["Total"]
	if obscure == true and Global.fade["Energia"]["Active"]:
		modulate.a -= delta / obscure_time_animation
	visible = Global.energia["General"] # al principio era el general, pero he decidido cambiarlo a las luces

func actualizar_skin():
	modulate.a = 1.0


func desactivar_parte(parte_id: int):
	partes[parte_id-1].modulate.a = 0.0
	actualizar_skin()

func activar_parte(parte_id: int):
	partes[parte_id-1].modulate.a = 1.0
	actualizar_skin()


func _on_timer_timeout() -> void:
	obscure = true

var tick_stop := false
func _on_main_game_on_tick_stop() -> void:
	tick_stop = true
	visible = false
