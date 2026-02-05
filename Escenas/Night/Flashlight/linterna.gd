extends Node2D

var linterna_activa_temporal := false
@onready var linternaPNG = $linternaPNG

@export var battery_item_charge := 50
@export var linterna_discharch_speed := 0.3
@export var linterna_recharch_speed := 0.4
@export var linterna_penalty := 10
var linterna_limiter := false
var did_click_on := false # funciona como un limiter pero para soltar el click
var linterna_recargando := false
var linterna_animacion_count := 0
signal Linterna_Activada_Switch()
signal Linterna_Recargando_Switch()

var tick_rate: float

func _ready():
	Foxy.connect("move_back", Callable(self, "foxy_animacion"))
	Items.consume_batteries.connect(add_batteries)
	set_process(true)
	# Aseguramos que el nodo ya existe y luego llamamos el setter
	set_linterna(linterna_activa_temporal)

func _process(_delta):
		
	global_position = get_global_mouse_position()
	
	if Global.linterna_bateria == 0:
		if linterna_activa_temporal:
			emit_signal("Linterna_Activada_Switch")
			linterna_activa_temporal = false
			linternaPNG.modulate.a = 0.0
		
	

func set_linterna(value):
	linterna_activa_temporal = value
	if linterna_activa_temporal:
		linternaPNG.modulate.a = 0.3
		if Global.linterna_bateria <= 10 and Global.linterna_bateria > 1: #hace que si no te queda suficiente bateria pa encender, se queda a 1%
			Global.linterna_bateria = 1
		else:
			Global.linterna_bateria -= linterna_penalty # cuanto quita la linterna 
	else:
		linternaPNG.modulate.a = 0.0


func _input(event):
	if event.is_action_pressed("Click") and linterna_limiter == false and linterna_recargando == false and $"..".camaras_activadas == false and linterna_animacion_count == 0 and $"..".tick_stop == false:
		$Linterna_Press.play()
		did_click_on = true
		set_linterna(!linterna_activa_temporal)
		emit_signal("Linterna_Activada_Switch")
	if event.is_action_released("Click") and did_click_on == true and linterna_recargando == false and $"..".camaras_activadas == false and linterna_animacion_count == 0 and $"..".tick_stop == false:
		$Linterna_Release.play()
		did_click_on = false

func cams_up():
	if linterna_activa_temporal:
		set_linterna(!linterna_activa_temporal)
		emit_signal("Linterna_Activada_Switch")
		did_click_on = false

func _on_boton_izquierda_mouse_entered_switch() -> void:
	linterna_limiter = !linterna_limiter
	
func _on_boton_derecha_mouse_entered_switch() -> void:
	linterna_limiter = !linterna_limiter

func _on_freddy_nose_freddy_nose_entered_switch() -> void:
	linterna_limiter = !linterna_limiter

func _on_oficina_detras_oficina_detras_mouse_switch() -> void:
	linterna_limiter = !linterna_limiter

func _on_vhs_colider_mouse_entered() -> void:
	linterna_limiter = true
func _on_vhs_colider_mouse_exited() -> void:
	linterna_limiter = false

func _on_battery_items_entered() -> void:
	linterna_limiter = true
func _on_battery_items_exited() -> void:
	linterna_limiter = false

func _on_watter_bottle_item_entered() -> void:
	linterna_limiter = true
func _on_watter_bottle_item_exited() -> void:
	linterna_limiter = false

func _on_timer_linterna_tic():
	if linterna_animacion_count == 0:
		Global.linterna_bateria -= 1

func _on_oficina_detras_linterna_recarga_switch_rebote() -> void:
	linterna_recargando = !linterna_recargando
	if linterna_activa_temporal:
		set_linterna(!linterna_activa_temporal)
		emit_signal("Linterna_Activada_Switch")
	emit_signal("Linterna_Recargando_Switch")

func _on_timer_recargar_linterna_tic_recarga() -> void:
	if Global.energia["Linterna"]:
		Global.linterna_bateria += 1

func add_batteries():
	
	Global.linterna_bateria += battery_item_charge
	return
	@warning_ignore("unreachable_code")
	
	var start := Global.linterna_bateria
	var end := start + battery_item_charge
	var time := 0.005 * battery_item_charge
	
	var tween := create_tween()
	tween.tween_method(
		func(value): Global.linterna_bateria = int(value),
		start,
		end,
		time
	)

func foxy_animacion():
	linterna_animacion(9)

func linterna_animacion(value):
	$linternaPNG.modulate.a = 0.0
	emit_signal("Linterna_Activada_Switch")
	linterna_animacion_count = value
	$linterna_animacion.start(0.3 * 5.0 / tick_rate)

func _on_linterna_animacion_timeout() -> void:
	linterna_animacion_count -= 1
	emit_signal("Linterna_Activada_Switch")
	if $linternaPNG.modulate.a > 0.0:
		$linternaPNG.modulate.a = 0.0
	else:
		$linternaPNG.modulate.a = 0.3
	if linterna_animacion_count > 0:
		if linterna_animacion_count > 3:
			$linterna_animacion.start((0.1 * (linterna_animacion_count - 2) / 3.0) * 5.0 / tick_rate)
		elif linterna_animacion_count == 1:
			$linterna_animacion.start(0.3 * 5.0 / tick_rate)
		else:
			$linterna_animacion.start((0.1 * 3.0 / 4.0) * 5.0 / tick_rate)
		if linterna_animacion_count == 1:
			Foxy.move_back_to()
