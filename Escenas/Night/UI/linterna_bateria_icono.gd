extends Node2D

var bateria := 100:
	get = get_bateria, set = set_bateria
var _bateria := 100
var pulse := true
var pulse_time: float
var obscure := false
var obscure_time_animation := 2.0
var obscure_time := 3.0

func _ready():
	
	Items.recharge_flashlight.connect(act_insta_skin)
	
	obscure_time = Global.fade["Linterna"]["Time"]
	obscure_time_animation = Global.fade["Linterna"]["Speed"]
	
	if obscure_time > 0:
		obscure = false
		$Timer_obscure.start(obscure_time)
	else:
		obscure = true
	_on_pulse_timer_timeout()
	actualizar_skin()

func _process(delta):
	
	if Global.linterna_bateria_show_anyways_because_i_dont_find_another_good_solution:
		set("bateria", bateria)
		Global.linterna_bateria_show_anyways_because_i_dont_find_another_good_solution = false
	if bateria != Global.linterna_bateria:
		bateria = Global.linterna_bateria
	
	if obscure == true and Global.fade["Linterna"]["Active"]:
		$".".modulate.a -= delta / obscure_time_animation

func actualizar_skin():
	if obscure == false: # hace que se pueda oscurecer
		$".".modulate.a = Global.linterna_skin["alpha_general"]
	$Base.modulate.a = Global.linterna_skin["alpha_base"]

	for nombre_paleta in Global.linterna_skin["partes"].keys():
		var paleta_node = get_node_or_null(nombre_paleta)
		if paleta_node == null:
			continue

		var alguna_visible = false

		for parte_id in Global.linterna_skin["partes"][nombre_paleta].keys():
			var data = Global.linterna_skin["partes"][nombre_paleta][parte_id]
			var parte_node = paleta_node.get_node_or_null(parte_id)
			if parte_node == null:
				continue

			var alpha = data["alpha"] if data["visible"] else 0.0
			parte_node.modulate.a = alpha
			if alpha > 0.0:
				alguna_visible = true
		
		paleta_node.visible = alguna_visible


func desactivar_parte(parte_id: String):
	for nombre_paleta in Global.linterna_skin["partes"].keys():
		if parte_id in Global.linterna_skin["partes"][nombre_paleta]:
			Global.linterna_skin["partes"][nombre_paleta][parte_id]["visible"] = false
	actualizar_skin()

func activar_parte(parte_id: String):
	for nombre_paleta in Global.linterna_skin["partes"].keys():
		if parte_id in Global.linterna_skin["partes"][nombre_paleta]:
			Global.linterna_skin["partes"][nombre_paleta][parte_id]["visible"] = true
	actualizar_skin()

func esta_parte_activada(parte_id: String) -> bool:
	for nombre_paleta in Global.linterna_skin["partes"].keys():
		if parte_id in Global.linterna_skin["partes"][nombre_paleta]:
			return Global.linterna_skin["partes"][nombre_paleta][parte_id]["visible"]
	return false

func get_bateria():
	return _bateria

func set_bateria(value: int):
	
	if obscure_time > 0:
		obscure = false
		$Timer_obscure.start(obscure_time)
	else:
		obscure = true
	actualizar_skin()
	
	_bateria = value
	
	if value == 100:
		pulse_time = 0.1
	
	if value < 100 and value > 80:
		pulse_time = (value - 80) / 35.0 + 0.1
	
	if value == 80:
		pulse_time = 0.1
	
	if value < 80 and value > 60:
		pulse_time = (value - 60) / 35.0 + 0.1
	
	if value == 60:
		pulse_time = 0.1
	
	if value < 60 and value > 40:
		pulse_time = (value - 40) / 35.0 + 0.1
	
	if value == 40:
		pulse_time = 0.1
	
	if value < 40 and value > 20:
		pulse_time = (value - 20) / 35.0 + 0.1
		
	if value == 20:
		pulse_time = 0.1
	
	if value < 20 and value > 0:
		pulse_time = (value) / 35.0 + 0.1
	
	if value == 0:
		pulse_time = 0.1

func act_insta_skin():
	actualizar_skin() # sospechosamente facil


func _on_pulse_timer_timeout() -> void:
	
	pulse = !pulse
	if pulse_time <= 0: # es solo por si acaso, en principio nunca sucede
		pulse_time = 0.1
	$Pulse_Timer.wait_time = pulse_time
	$Pulse_Timer.start()
	
	if bateria == 100:
		activar_parte("5")
		activar_parte("4")
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria > 80 and bateria < 100:
		
		if esta_parte_activada("4") == false:
			desactivar_parte("5")
			activar_parte("4")
			activar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return
		
		if pulse == true and pulse_time != 1:
			activar_parte("5")
		else:
			desactivar_parte("5")
		activar_parte("4")
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria == 80:
		desactivar_parte("5")
		activar_parte("4")
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria > 60 and bateria < 80:
		
		if esta_parte_activada("5"):
			desactivar_parte("5")
			activar_parte("4")
			activar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return
		if esta_parte_activada("3") == false:
			desactivar_parte("5")
			desactivar_parte("4")
			activar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return

		desactivar_parte("5")
		if pulse == true and pulse_time != 1:
			activar_parte("4")
		else:
			desactivar_parte("4")
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria == 60:
		desactivar_parte("5")
		desactivar_parte("4")
		activar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria > 40 and bateria < 60:
		
		if esta_parte_activada("4"):
			desactivar_parte("5")
			desactivar_parte("4")
			activar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return
		if esta_parte_activada("2") == false:
			desactivar_parte("5")
			desactivar_parte("4")
			desactivar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return
		
		desactivar_parte("5")
		desactivar_parte("4")
		if pulse == true and pulse_time != 1:
			activar_parte("3")
		else:
			desactivar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria == 40:
		desactivar_parte("5")
		desactivar_parte("4")
		desactivar_parte("3")
		activar_parte("2")
		activar_parte("1")
		return
	
	if bateria > 20 and bateria < 40:
		
		if esta_parte_activada("3"):
			desactivar_parte("5")
			desactivar_parte("4")
			desactivar_parte("3")
			activar_parte("2")
			activar_parte("1")
			return
		if esta_parte_activada("1") == false:
			desactivar_parte("5")
			desactivar_parte("4")
			desactivar_parte("3")
			desactivar_parte("2")
			activar_parte("1")
			return
		
		desactivar_parte("5")
		desactivar_parte("4")
		desactivar_parte("3")
		if pulse == true and pulse_time != 1:
			activar_parte("2")
		else:
			desactivar_parte("2")
		activar_parte("1")
		return
	
	if bateria == 20:
		desactivar_parte("5")
		desactivar_parte("4")
		desactivar_parte("3")
		desactivar_parte("2")
		activar_parte("1")
		return
	
	if bateria > 0 and bateria < 20:
		
		if esta_parte_activada("2"):
			desactivar_parte("5")
			desactivar_parte("4")
			desactivar_parte("3")
			desactivar_parte("2")
			activar_parte("1")
			return
		
		desactivar_parte("5")
		desactivar_parte("4")
		desactivar_parte("3")
		desactivar_parte("2")
		if pulse == true and pulse_time != 1:
			activar_parte("1")
		else:
			desactivar_parte("1")
		return
	
	if bateria == 0:
		desactivar_parte("5")
		desactivar_parte("4")
		desactivar_parte("3")
		desactivar_parte("2")
		desactivar_parte("1")
		return


func _on_timer_obscure_timeout() -> void:
	obscure = true
