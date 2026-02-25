extends Node2D

@export var al_max_time_on_insanity: float = 50.0
@export var al_min_time_on_insanity: float = 700.0
@export var al_max_time_mid := 20.0 # estas probabilidades no tienen en cuenta el tiempo de alucinaciones_cooldown
@export var al_min_time_mid := 5.0 # a esto habria que sumarle el alucinaciones_cooldown
var alucinaciones_cooldown: int

var tick_speed: float
var tick_rate: float
var tick_stop := false

@export_group("nodes")
@export var oficina: Node2D
@export var oficina_detras: Node2D
@export var freddy_nose: Node2D
@export var linterna: Node2D
@export var cheats: Node
@export var transicion: Node
#control:
@export var tick: Timer
@export var esc_timer: Timer
#---
@export var mouse_custom: Node2D
@export var camaras_control: Node2D
@export var camaras: Node2D


var _camaras_activadas: bool
var camaras_activadas := false:
	get: return _camaras_activadas
	set(value): set_camaras_activadas(value)

var bonnie_cam_wait: int
var chica_cam_wait: int

signal jumpscare(who: String)
signal alucinations(on: bool)

func set_camaras_activadas(value):
	_camaras_activadas = value
	if value:
		linterna.cams_up() # linterna
	freddy_nose.cam_warp = value # Nariz de freddy
	Bonnie.cam_activa = value
	Chica.cam_activa = value
	Freddy.cam_activa = value
	oficina.cams_open = value


func _enter_tree() -> void: # antes que ready
	save_volume_linear = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), 0.0)

var save_volume_linear: float
const TIEMPO_TRANSICION := 5.0
func _transition_in() -> void:
	
	transicion.modulate.a = 1.0
	await get_tree().create_timer(0.5).timeout
	
	var bus := AudioServer.get_bus_index("Master")
	var tween := create_tween()
	
	tween.parallel() # Hace que todos los tweens internos ocurran al mismo tiempo
	tween.tween_property(transicion, "modulate:a", 0.0, TIEMPO_TRANSICION)
	
	tween.tween_method(
		func(value: float) -> void:
			AudioServer.set_bus_volume_linear(bus, value),
		AudioServer.get_bus_volume_linear(bus),
		save_volume_linear,
		TIEMPO_TRANSICION
	)

func _ready():
	bonnie_cam_wait = 0
	chica_cam_wait = 0
	Global.reset_night()
	Bonnie.reset()
	Chica.reset()
	Freddy.reset()
	Foxy.reset()
	tick.start()
	change_tick_rate(cheats.tick_rate)
	tick_speed = 1.0 / tick_rate
	
	Items.night_starts()
	Global.night_starts()
	
	_transition_in()


func _input(event):
	if event.is_action_pressed("Esc"):
		esc_timer.start()  # Empieza el conteo
	
	elif event.is_action_released("Esc"):
		esc_timer.stop()  # Se cancela si suelta antes de tiempo

func _on_esc_timer_timeout():
	# Si al terminar el tiempo todavía se está presionando Esc, cambiamos de escena
	if Input.is_action_pressed("Esc"):
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "escaped")
		Global.escena_previa = "Main_Game"
		Global.reset_night()
		tick.stop()
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), save_volume_linear) # porsia no se ha terminado de reiniciar
		if Global.noche == 0:
			get_tree().change_scene_to_file("res://Escenas/Menu/CN/custom_night_selecter.tscn") #actualizar
		else:
			get_tree().change_scene_to_file("res://Escenas/Menu/MainMenu/Menu_Principal.tscn") #actualizar


func _on_tick_timeout() -> void:
	tick_call()
	if not tick_stop:
		tick.start(tick_speed)


func tick_call():
	Bonnie.tick()
	Chica.tick()
	Freddy.tick()
	Foxy.tick()
	Global.tick()
	
	alucinacion_attempt()
	
	camaras.hora = Global.time_hour
	
	if Global.time_hour == 6:
		tick_stop = true
		game_over(true)
	
	if cheats.invencibility:
		pass
	
	elif Bonnie.position == "office":
		if camaras_activadas == true:
			if bonnie_cam_wait < 50:
				bonnie_cam_wait += 1
				return
			else:
				camaras_control.toggle_cams()
		if oficina.girando != 0 and oficina.girando != 3:
			return
		emit_signal("jumpscare", "Bonnie")
	
	elif Chica.position == "office":
		if camaras_activadas == true:
			if chica_cam_wait < 50:
				chica_cam_wait += 1
				return
			else:
				camaras_control.toggle_cams()
		if oficina.girando != 0 and oficina.girando != 3:
			return
		emit_signal("jumpscare", "Chica")
	
	elif Freddy.position == "office":
		if camaras_activadas == true:
			return
		if oficina.girando != 0: # freddy no te salta mientras miras hacia atras
			return
		emit_signal("jumpscare", "Freddy")
	
	elif Foxy.room == "office":
		if camaras_activadas == true:
			return
		if oficina.girando != 0 and oficina.girando != 3:
			return
		emit_signal("jumpscare", "Foxy")

func _on_jumpscare(_who: String) -> void:
	tick_stop = true
	stop_alucinations()
	oficina_detras.stop_everything = true
	camaras_control.game_over = true
	mouse_custom.override_alpha = true
	mouse_custom.modulate.a = 0.0

func alucinacion_attempt():
	
	if alucinaciones_cooldown > 0:
		alucinaciones_cooldown -= 1
		return
	
	if Global.insanity < al_max_time_on_insanity:
		return
	
	var insanity_clamp = clamp(Global.insanity, al_max_time_on_insanity, al_min_time_on_insanity)
	
	var T = al_max_time_mid - float(insanity_clamp - al_max_time_on_insanity) * ((al_max_time_mid - al_min_time_mid) / (al_min_time_on_insanity - al_max_time_on_insanity)) # no se muy bien como funciona, pero funciona
	var probability =  1.0 / (T * 5.0) # 5 chequeos por segund
	
	if randf() < probability:
		if not camaras.activado and (Global.energia["Luces"] or randi_range(0, 1) == 1):
			emit_signal("alucinations", true)
			change_tick_rate(cheats.tick_rate * 2)
			alucinaciones_cooldown = 200 - 180 * ((insanity_clamp - al_max_time_on_insanity) / al_min_time_on_insanity)

func stop_alucinations():
	change_tick_rate(cheats.tick_rate)
	emit_signal("alucinations", false)

func change_tick_rate(new_tick: float):
	tick_rate = new_tick
	tick_speed = 1.0 / new_tick
	linterna.tick_rate = new_tick

func game_over(win: bool):
	
	Global.reset_night()
	
	if win:
		Global.escena_previa = "Main_game"
		get_tree().change_scene_to_file("res://Escenas/Night/6Am/6_am.tscn") #actualizar
	else:
		
		if go_to_death_minigame():
			Global.escena_previa = "Main_game"
			get_tree().change_scene_to_file("res://escenas/DeadMinigames/death_minigame_loader.tscn") #actualizar
		else:
			Global.escena_previa = "Main_game"
			get_tree().change_scene_to_file("res://Escenas/Menu/DeadScene/Dead_Scene.tscn") #actualizar


func go_to_death_minigame() -> bool:
	
	if Global.noche == 0: # custom night
		return false
	
	if not Global.mapa["death_minigames"]: # si death minigames esta desactivado
		return false
	
	if Global.killed_by == "bonnie":
		if Global.dm["bonnie"] == Global.Estado.STANDBY:
			return true
	
	elif Global.killed_by == "chica":
		if Global.dm["bonnie"] != Global.Estado.STANDBY and Global.dm["chica"] == Global.Estado.STANDBY:
			return true
	
	elif Global.killed_by == "freddy":
		if Global.dm["bonnie"] != Global.Estado.STANDBY and Global.dm["chica"] != Global.Estado.STANDBY and Global.dm["freddy"] == Global.Estado.STANDBY:
			return true
	
	elif Global.killed_by == "foxy":
		if Global.dm["bonnie"] != Global.Estado.STANDBY and Global.dm["chica"] != Global.Estado.STANDBY and Global.dm["freddy"] != Global.Estado.STANDBY and Global.dm["foxy"] == Global.Estado.STANDBY:
			return true
	
	return false


func _on_jumpscare_bonnie_jumpscare_end() -> void:
	Global.killed_by = "bonnie"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 1
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "YOU GOT REPRODUCED")

func _on_jumpscare_chica_jumpscare_end() -> void:
	Global.killed_by = "chica"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 2
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "YOU GOT CHICKEND")

func _on_jumpscare_freddy_jumpscare_end() -> void:
	Global.killed_by = "freddy"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 3
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "YOU GOT FREDDYED")

func _on_jumpscare_foxy_jumpscare_end() -> void:
	Global.killed_by = "foxy"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 4
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "YOU GOT FOXED")
