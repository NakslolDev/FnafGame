extends Timer

signal Linterna_tic_recarga  # Señal que mandás cada segundo
@onready var timer := $"."
var linterna_switch := false

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	emit_signal("Linterna_tic_recarga") 


func _on_linterna_linterna_recargando_switch() -> void:
	linterna_switch = !linterna_switch
	if linterna_switch:
			Global.linterna_bateria_show_anyways_because_i_dont_find_another_good_solution = true
			timer.start($"..".linterna_recharch_speed * 5.0 / $"..".tick_rate)
	else:
		timer.stop()
