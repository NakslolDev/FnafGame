extends Node2D

@export var linterna: Sprite2D
const LINTERNA_ALPHA := 0.2
var cam_lights: bool

var camara_activa := 1

@export_group("Nodes")
@export var cams: Node2D
@export var alucination_control: Node
@export var area_minimapa: Area2D
@export var ruido: Node2D
@export var no_energy: Sprite2D
@export var dot: Sprite2D

@export var time: Label
@export var day: Label
@export var no_cam_lights: AudioStreamPlayer

@export var si_shader: CanvasLayer
@export var no_shader: CanvasLayer
@export var canvas_layer_shader: CanvasLayer

@export var minimapa_botones: Sprite2D
@export var minimapa_ductos: Sprite2D


var _hora := 0
var hora: int:
	get: return _hora
	set(value): set_hora(value)

func set_hora(value):
	_hora = value
	if value == 0:
		time.text = "12 PM"
	else:
		time.text = str(value) + " AM"


var _activado := false
var activado: bool:
	get: return _activado
	set(value): set_activado(value)

func set_activado(value):
	_activado = value
	#cams/Cam_6.act_combination()
	visible = value
	no_shader.visible = value
	si_shader.visible = value
	canvas_layer_shader.visible = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), !(value and camara_activa == 6))
	alucination_control.alucinations(value)
	for cam in cams.cameras:
		cam.actualizar_cams()
	if value:
		act_light()
		ruido._on_minimapa_botones_cam_act()
		ruido._static.play()
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Opend cams")
	else:
		cam_lights = false
		ruido._static.stop()
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Closed cams")


func _ready():
	Global.energia_actualizada.connect(energia_act)
	Global.set_energia_consumption("Camaras", 0)
	Global.set_energia_consumption("Cam_lights", 0)
	no_energy.visible = false
	
	for heat in duct_heat_sprites:
		heat.modulate.a = 0.0
	
	camara_activa = 1
	act_day()
	set_activado(activado)
	act_heater()
	set_ductos(ductos)

func _process(delta):
	act_heater_sprite(delta)


func _input(event):
	if not activado:
		return
	if event.is_action_pressed("Click") and can_cam_light():
		if camara_activa != 6 and Global.energia["Camaras"] == true and (Global.energia_consumption["Total"] < Global.energia_consumption["Max"] or not Global.misc["Auto_cam_lights"]):
			cam_lights = true # si abres las camaras con el raton en el minimapa, te deja iluminar una vez cuando no deveria
			act_light() # lo voy a dejar, pues ni idea de como solucionarlo y como la luz no te puede joder el sistema, pues como que da igual...
		else:
			no_cam_lights.play()
			return
	elif event.is_action_released("Click"):
		cam_lights = false
		act_light()

func can_cam_light() -> bool:
	for overlaping_areas in area_minimapa.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return false
	return true

func _on_minimapa_botones_cam_act() -> void:
	if camara_activa == 6:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), false)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Cam 6 Sounds"), true)

func act_light():
	if cam_lights and Global.energia["Camaras"]:
		Global.set_energia_consumption("Cam_lights", 1)
		linterna.modulate.a = LINTERNA_ALPHA
		Freddy.cam_light = true
		Bonnie.cam_light = true
		alucination_control.flashlight(camara_activa)
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "cam light on")
	else:
		Global.set_energia_consumption("Cam_lights", 0)
		linterna.modulate.a = 0.0
		Freddy.cam_light = false
		Bonnie.cam_light = false
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "cam light off")
	
	for cam in cams.cameras:
		cam.actualizar_cams()

func act_day():
	if Global.noche == 0:
		day.text = "Sunday"
	if Global.noche == 1:
		day.text = "Monday"
	if Global.noche == 2:
		day.text = "Tuesday"
	if Global.noche == 3:
		day.text = "Wednesday"
	if Global.noche == 4:
		day.text = "Thursday"
	if Global.noche == 5:
		day.text = "Friday"
	if Global.noche == 6:
		day.text = "Saturday"

func energia_act():
	if Global.energia["Camaras"]:
		no_energy.visible = false
		if activado:
			Global.set_energia_consumption("Camaras", 1)
			if cam_lights:
				Global.set_energia_consumption("Cam_lights", 1)
	elif not Global.energia["Camaras"]:
		no_energy.visible = true
		Global.set_energia_consumption("Camaras", 0)
		Global.set_energia_consumption("Cam_lights", 0)
		dot.visible = false
	act_heater()

##Duct heater & duct heater animation
# For some reason I decided this goes here... Whatever, it works and I am not changing it now

@export var duct_heat_sprites: Array[Sprite2D]

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

var _ductos := false
var ductos: bool:
	get: return _ductos
	set(value): set_ductos(value)

func set_ductos(value):
	_ductos = value
	if value:
		minimapa_botones.visible = false
		minimapa_ductos.visible = true
	else:
		minimapa_botones.visible = true
		minimapa_ductos.visible = false

func act_heater():
	print("")
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Heater acted:")
	var some: bool = false
	for i in range(1,9): # 1-8
		if duct_heater[str(i)]:
			some = true
			print("heater ", i, "active")
	if not some: print("no heater active :(")
	print("")
	
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
		
		var duct_node = duct_heat_sprites[i-1]
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
