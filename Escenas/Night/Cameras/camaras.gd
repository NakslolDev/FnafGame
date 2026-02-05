extends Node2D

var _activado := false
var activado: bool:
	get: return _activado
	set(value): set_activado(value)

func set_activado(value):
	_activado = value
	$Si_Shader/Cams/Cam_6.act_combination()
	if value:
		cam_flipped_discount -= 1
		alucinations_cams(Global.insanity)
		act_light()
		$".".modulate.a = 1.0
		$No_Shader.visible = true
		$Si_Shader.visible = true
		$CanvasLayer_Shader.visible = true
		$No_Shader/Ruido._on_minimapa_botones_cam_act()
		$No_Shader/Ruido/Static.play()
		if camara_activa == 6:
			AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), false)
	else:
		cam_lights = false
		$".".modulate.a = 0.0
		$No_Shader.visible = false
		$Si_Shader.visible = false
		$CanvasLayer_Shader.visible = false
		$No_Shader/Ruido/Static.stop()
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), true)

func _on_minimapa_botones_cam_act() -> void:
	if camara_activa == 6:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), true)

var _ductos := false
var ductos: bool:
	get: return _ductos
	set(value): set_ductos(value)

var _hora := 0
var hora: int:
	get: return _hora
	set(value): set_hora(value)

func set_hora(value):
	_hora = value
	if value == 0:
		$No_Shader/Border/VBoxContainer/Time.text = "12 PM"
	else:
		$No_Shader/Border/VBoxContainer/Time.text = str(value) + " AM"

var cam_lights: bool
var cam_lights_limit := false

var camara_activa := 1

var duct_heater := {
	"1": false,
	"2": false,
	"3": false,
	"4": false,
	"5": false,
	"6": false,
	"7": false,
	"8": false,
}
var duct_not_heater_animation := { # true = alpha+
	"1": true,
	"2": true,
	"3": true,
	"4": true,
	"5": true,
	"6": true,
	"7": true,
	"8": true,
}

signal alucinations
var memoria := [false, false, false, false, false, false, false, false, false, false, false, false, false]
var cam_flipped_discount := 0

func _input(event):
	if not activado:
		return
	if event.is_action_pressed("Click") and not cam_lights_limit:
		if camara_activa != 6 and Global.energia["Camaras"] == true and (Global.energia_consumption["Total"] < Global.energia_consumption["Max"] or not Global.misc["Auto_cam_lights"]):
			cam_lights = true # si abres las camaras con el raton en el minimapa, te deja iluminar una vez cuando no deveria
			act_light() # lo voy a dejar, pues ni idea de como solucionarlo y como la luz no te puede joder el sistema, pues como que da igual...
		else:
			$No_Shader/NoCamLights.play()
			return
	elif event.is_action_released("Click"):
		cam_lights = false
		act_light()

func act_light():
	if cam_lights and Global.energia["Camaras"]:
		Global.set_energia_consumption("Cam_lights", 1)
		$Si_Shader/Linterna.modulate.a = 0.5
		Freddy.cam_light = true
		if memoria[camara_activa - 1] == true:
			memoria[camara_activa - 1] = false
			$Si_Shader/Cams.act_cam(camara_activa)
	else:
		Global.set_energia_consumption("Cam_lights", 0)
		$Si_Shader/Linterna.modulate.a = 0.0
		Freddy.cam_light = false

func act_all_cams():
	$Si_Shader/Cams/Cam_1.actualizar_cams()
	$Si_Shader/Cams/Cam_2.actualizar_cams()
	$Si_Shader/Cams/Cam_3.actualizar_cams()
	$Si_Shader/Cams/Cam_4.actualizar_cams()
	$Si_Shader/Cams/Cam_5.actualizar_cams()
	$Si_Shader/Cams/Cam_6.actualizar_cams()
	$Si_Shader/Cams/Cam_7.actualizar_cams()
	$Si_Shader/Cams/Cam_8.actualizar_cams()
	$Si_Shader/Cams/Cam_9.actualizar_cams()
	$Si_Shader/Cams/Cam_10A.actualizar_cams()
	$Si_Shader/Cams/Cam_10B.actualizar_cams()
	$Si_Shader/Cams/Cam_11A.actualizar_cams()
	$Si_Shader/Cams/Cam_11B.actualizar_cams()

func alucinations_cams(insano: int):
	
	if cam_flipped_discount <= 0 or memoria == [false, false, false, false, false, false, false, false, false, false, false, false, false]: # si no envio la señal, las alucinaciones se mantienen
		cam_flipped_discount = randi_range(5, 10)
	else:
		return
	
	if not insano > randi_range(0, 500):
		return
	
	var al_intensity := 0
	var rand_number := 0
	while rand_number < insano:
		al_intensity += 1
		if al_intensity < 8:
			rand_number = min(randi_range(0, 1000), randi_range(0, 1000)) # pilla el minimo de entre estos numeros
		else:
			break
	do_alucinations(al_intensity)

func do_alucinations(many: int):
	memoria = [false, false, false, false, false, false, false, false, false, false, false, false, false]
	
	while many > 0:
		many -= 1
		
		var cam := randi_range(1, 13)
		while memoria[cam - 1] == true:
			cam = randi_range(1, 13)
		memoria[cam - 1] = true
	
	emit_signal("alucinations")

func _ready():
	Global.connect("energia_actualizada", Callable(self, "energia_act"))
	Global.set_energia_consumption("Camaras", 0)
	Global.set_energia_consumption("Cam_lights", 0)
	$Si_Shader/No_energy.modulate.a = 0.0
	
	$"No_Shader/MinimapaDuctos/1".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/2".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/3".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/4".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/5".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/6".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/7".modulate.a = 0.0
	$"No_Shader/MinimapaDuctos/8".modulate.a = 0.0
	camara_activa = 1
	act_day()
	set_activado(activado)
	act_heater()
	set_ductos(ductos)

func _process(delta):
	act_heater_sprite(delta)

func act_day():
	if Global.noche == 0:
		$No_Shader/Border/VBoxContainer/Day.text = "Sunday"
	if Global.noche == 1:
		$No_Shader/Border/VBoxContainer/Day.text = "Monday"
	if Global.noche == 2:
		$No_Shader/Border/VBoxContainer/Day.text = "Tuesday"
	if Global.noche == 3:
		$No_Shader/Border/VBoxContainer/Day.text = "Wednesday"
	if Global.noche == 4:
		$No_Shader/Border/VBoxContainer/Day.text = "Thursday"
	if Global.noche == 5:
		$No_Shader/Border/VBoxContainer/Day.text = "Friday"
	if Global.noche == 6:
		$No_Shader/Border/VBoxContainer/Day.text = "Saturday"

func set_ductos(value):
	_ductos = value
	if get_node_or_null("No_Shader/MinimapaBotones") == null:
		return
	if value:
		$No_Shader/MinimapaBotones.modulate.a = 0.0
		$No_Shader/MinimapaDuctos.modulate.a = 1.0
	else:
		$No_Shader/MinimapaBotones.modulate.a = 1.0
		$No_Shader/MinimapaDuctos.modulate.a = 0.0

func energia_act():
	if Global.energia["Camaras"]:
		$Si_Shader/No_energy.modulate.a = 0.0
		if activado:
			Global.set_energia_consumption("Camaras", 1)
			if cam_lights:
				Global.set_energia_consumption("Cam_lights", 1)
	elif not Global.energia["Camaras"]:
		$Si_Shader/No_energy.modulate.a = 1.0
		Global.set_energia_consumption("Camaras", 0)
		Global.set_energia_consumption("Cam_lights", 0)
		$No_Shader/Border/Dot.modulate.a = 0.0
	act_heater()

func act_heater():
	
	if Global.energia["Heater"] == false:
		for i in range(1, 9): # 1-8
			Foxy.duct_heater[str(i)] = false
		Global.set_energia_consumption("Heater", 0)
		return
	
	for i in range(1, 9): # 1-8
		Foxy.duct_heater[str(i)] = duct_heater[str(i)]
	
	var heater_consumption := 0
	for i in range(1, 9): # 1-8
		if duct_heater[str(i)]:
			heater_consumption += 1
	Global.set_energia_consumption("Heater", heater_consumption)

func act_heater_sprite(delta):
	
	for i in range(1, 9):
		
		var duct_node = get_node("No_Shader/MinimapaDuctos/" + str(i))
		if duct_heater[str(i)] and Global.energia["Heater"]:
			if duct_node.modulate.a < 0.5:
				var new_alpha = duct_node.modulate.a + 0.2 * delta
				duct_node.modulate.a = min(new_alpha, 0.5)
		
		elif duct_heater[str(i)] and Global.energia["Heater"] == false:
			if duct_node.modulate.a > 0.3:
				duct_node.modulate.a -= 0.3 * delta
			elif duct_not_heater_animation[str(i)]:
				var new_alpha = duct_node.modulate.a + 0.3 * delta
				duct_node.modulate.a = min(new_alpha, 0.3)
				if abs(duct_node.modulate.a - 0.3) < 0.001:
					duct_not_heater_animation[str(i)] = false
			else:
				var new_alpha = duct_node.modulate.a - 0.3 * delta
				duct_node.modulate.a = max(new_alpha, 0.0)
				if abs(duct_node.modulate.a) < 0.001:
					duct_not_heater_animation[str(i)] = true
		
		else:
			if duct_node.modulate.a > 0.0:
				var new_alpha = duct_node.modulate.a - 0.2 * delta
				duct_node.modulate.a = max(new_alpha, 0.0)


func _on_area_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["1"] = !duct_heater["1"]
		act_heater() 

func _on_area_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["2"] = !duct_heater["2"]
		act_heater() 

func _on_area_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["3"] = !duct_heater["3"]
		act_heater() 

func _on_area_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["4"] = !duct_heater["4"]
		act_heater() 

func _on_area_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["5"] = !duct_heater["5"]
		act_heater() 

func _on_area_6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["6"] = !duct_heater["6"]
		act_heater() 

func _on_area_7_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["7"] = !duct_heater["7"]
		act_heater() 

func _on_area_8_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if ductos and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		duct_heater["8"] = !duct_heater["8"]
		act_heater() 


func limit_light_minimapa(limit: bool):
	cam_lights_limit = limit

func _on_area_minimapa_mouse_entered() -> void:
	limit_light_minimapa(true)

func _on_area_minimapa_mouse_exited() -> void:
	limit_light_minimapa(false)
