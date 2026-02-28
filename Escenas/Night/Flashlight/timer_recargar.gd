extends Timer

signal Linterna_tic_recarga
var linterna_switch := false
@export var linterna: Node2D

func _ready():
	timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	emit_signal("Linterna_tic_recarga") 


func _on_linterna_linterna_recargando_switch() -> void:
	linterna_switch = !linterna_switch
	if linterna_switch:
			Global.linterna_bateria_show_anyways_because_i_dont_find_another_good_solution = true
			start(linterna.linterna_recharch_speed * 5.0 / linterna.tick_rate)
	else:
		stop()
