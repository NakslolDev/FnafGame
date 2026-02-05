extends Node2D

@export var al_max_time_on_insanity: float = 50.0
@export var al_min_time_on_insanity: float = 700.0
@export var al_max_time_mid := 20.0 # estas probabilidades no tienen en cuenta el tiempo de alucinaciones_cooldown
@export var al_min_time_mid := 5.0 # a esto habria que sumarle el alucinaciones_cooldown
var alucinaciones_cooldown: int

var tick_speed: float
var tick_rate: float
var tick_stop := false

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
		$Linterna.cams_up() # linterna
		$"Oficina/Freddy nose".cam_warp = true # Nariz de freddy
		Bonnie.cam_activa = true
		Chica.cam_activa = true
		Freddy.cam_activa = true
		$"Area Camera Movement".stop_movement()
	else:
		$"Oficina/Freddy nose".cam_warp = false # Nariz de freddy
		Bonnie.cam_activa = false
		Chica.cam_activa = false
		Freddy.cam_activa = false
		$"Area Camera Movement".remember()

@export var transicion := 5
var transicionando: bool
@export var transicion_loc: Node

func _ready():
	bonnie_cam_wait = 0
	chica_cam_wait = 0
	Global.reset_night()
	Global.night_starts()
	Items.night_starts()
	Bonnie.reset()
	Chica.reset()
	Freddy.reset()
	Foxy.reset()
	$Control/Tick.start()
	change_tick_rate($Cheats.tick_rate)
	tick_speed = 1.0 / tick_rate
	transicionando = true
	transicion_loc.modulate.a = 1.0
	$Camaras_Control/Camaras.act_all_cams() # es necesario activarlos otra vez para que cojan los verdaderos datos de los animatronicos
	$True_No_Shader/Animatronic_Map.act_first()

func _process(delta):
	
	if $True_No_Shader/Tick_label.modulate.a > 0.001:
		$True_No_Shader/Tick_label.modulate.a -= 5 * delta
	
	if $Cheats.see_light_batery:
		$True_No_Shader/VBoxContainer/Batery_Label.visible = true
		$True_No_Shader/VBoxContainer/Batery_Label.text = str(Global.linterna_bateria) + "%"
	else:
		$True_No_Shader/VBoxContainer/Batery_Label.visible = false
	
	if transicionando:
		transicion_loc.modulate.a -= delta / transicion
		if transicion_loc.modulate.a <= 0:
			transicion_loc.modulate.a = 0
			transicionando = false
	
func _input(event):
	if event.is_action_pressed("Esc"):
		$Control/ESC_Timer.start()  # Empieza el conteo
	
	elif event.is_action_released("Esc"):
		$Control/ESC_Timer.stop()  # Se cancela si suelta antes de tiempo

func _on_esc_timer_timeout():
	# Si al terminar el tiempo todavía se está presionando Esc, cambiamos de escena
	if Input.is_action_pressed("Esc"):
		Global.escena_previa = "Main_Game"
		if Global.noche == 0:
			get_tree().change_scene_to_file("res://escenas/custom_night_selecter.tscn") #actualizar
		else:
			get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn") #actualizar


func _on_tick_timeout() -> void:
	tick_call()
	if not tick_stop:
		$Control/Tick.start(tick_speed)

func tick_call():
	if $Cheats.tick_count:
		$True_No_Shader/Tick_label.modulate.a = 1.0
	Bonnie.tick()
	Chica.tick()
	Freddy.tick()
	Foxy.tick()
	Global.tick()
	
	alucinacion_attempt()
	
	$Camaras_Control/Camaras.hora = Global.time_hour
	$True_No_Shader/VBoxContainer/Insanity_label.text = "Insanity: " + str(Global.insanity)
	if Global.time_minute < 10:
		$True_No_Shader/VBoxContainer/Time_label.text = str(Global.time_hour) + ":0" + str(Global.time_minute)
	else:
		$True_No_Shader/VBoxContainer/Time_label.text = str(Global.time_hour) + ":" + str(Global.time_minute)
	
	if Global.time_hour == 6:
		tick_stop = true
		game_over(true)
	
	if $Cheats.invencibility:
		pass
	
	elif Bonnie.position == "office":
		if camaras_activadas == true:
			if bonnie_cam_wait < 50:
				bonnie_cam_wait += 1
				return
			else:
				$Camaras_Control.toggle_cams()
		if $Oficina.girando != 0 and $Oficina.girando != 3:
			return
		emit_signal("jumpscare", "Bonnie")
	
	elif Chica.position == "office":
		if camaras_activadas == true:
			if chica_cam_wait < 50:
				chica_cam_wait += 1
				return
			else:
				$Camaras_Control.toggle_cams()
		if $Oficina.girando != 0 and $Oficina.girando != 3:
			return
		emit_signal("jumpscare", "Chica")
	
	elif Freddy.position == "office":
		if camaras_activadas == true:
			return
		if $Oficina.girando != 0: # freddy no te salta mientras miras hacia atras
			return
		emit_signal("jumpscare", "Freddy")
	
	elif Foxy.room == "office":
		if camaras_activadas == true:
			return
		if $Oficina.girando != 0 and $Oficina.girando != 3:
			return
		emit_signal("jumpscare", "Foxy")

func _on_jumpscare(_who: String) -> void:
	tick_stop = true
	stop_alucinations()
	$Oficina/Oficina_Detras.stop_everything = true
	$Camaras_Control.game_over = true
	$Mouse_Custom.override_alpha = true
	$Mouse_Custom.modulate.a = 0.0

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
		if not $Camaras_Control/Camaras.activado and (Global.energia["Luces"] or randi_range(0, 1) == 1):
			emit_signal("alucinations", true)
			change_tick_rate($Cheats.tick_rate * 2)
			alucinaciones_cooldown = 200 - 180 * ((insanity_clamp - al_max_time_on_insanity) / al_min_time_on_insanity)

func stop_alucinations():
	change_tick_rate($Cheats.tick_rate)
	emit_signal("alucinations", false)

func change_tick_rate(new_tick: float):
	tick_rate = new_tick
	tick_speed = 1.0 / new_tick
	$Linterna.tick_rate = new_tick

func game_over(win: bool):
	
	if win:
		Global.escena_previa = "Main_game"
		get_tree().change_scene_to_file("res://escenas/6_am.tscn") #actualizar
	else:
		
		if go_to_death_minigame():
			Global.escena_previa = "Main_game"
			get_tree().change_scene_to_file("res://escenas/death_minigame_loader.tscn") #actualizar
		else:
			Global.escena_previa = "Main_game"
			get_tree().change_scene_to_file("res://escenas/Dead_Scene.tscn") #actualizar


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
	print("YOU GOT REPRODUCED")

func _on_jumpscare_chica_jumpscare_end() -> void:
	Global.killed_by = "chica"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 2
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print("YOU GOT CHICKEND")

func _on_jumpscare_freddy_jumpscare_end() -> void:
	Global.killed_by = "freddy"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 3
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print("YOU GOT FREDDYED")

func _on_jumpscare_foxy_jumpscare_end() -> void:
	Global.killed_by = "foxy"
	if randi_range(0, 5) != 0:
		Global.dead_scene_type = 4
	else:
		Global.dead_scene_type = 0
	game_over(false)
	print("YOU GOT FOXED")
