extends Timer

signal Linterna_tic 
@export var linterna: Node2D

func _ready():
	timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	emit_signal("Linterna_tic") 

func _on_linterna_linterna_activada_switch(value: bool, animation: bool) -> void:
	if value and not animation:
		start(linterna.linterna_discharch_speed * 5.0 / linterna.tick_rate) # hace que el tiempo dependa del tick rate. Si este es mayor, se gasta más rapido
	else:
		stop()
