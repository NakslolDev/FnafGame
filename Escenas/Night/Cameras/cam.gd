extends Node2D

var timer_active := false
var mover_izquierda := false
var ultima_pos_3 := 960.0
@export var velocidad: float
signal cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, alucinations: bool)

func _ready():
	Freddy.connect("movement", Callable(self, "movement_freddy"))
	Bonnie.connect("movement", Callable(self, "movement_bonnie"))
	Chica.connect("movement", Callable(self, "movement_chica"))
	Foxy.connect("movement", Callable(self, "movement_foxy"))
	_on_minimapa_botones_cam_act()

func act_cam(cam: int):
	emit_signal("cam_act", false, 0, 0, cam, true)

func _physics_process(delta: float) -> void:
	if $"../..".camara_activa != 3:
		if position.x != 960:
			position.x = 960
		return
	if timer_active:
		return
	if (position.x <= 480.0 and mover_izquierda == false) or (position.x >= 1440.0 and mover_izquierda == true):
		if position.x < 480.0:
			position.x = 480.0
		if position.x > 1440.0:
			position.x = 1440.0
		ultima_pos_3 = position.x
		timer_active = true
		$Timer_movement_Cam_2.start()
		mover_izquierda = !mover_izquierda
		return
	if mover_izquierda:
		position.x += velocidad * delta
	else:
		position.x -= velocidad * delta
	ultima_pos_3 = position.x
	
	if position.x <= 960.0:
		Freddy.looking_left_on_specificly_cam_3 = false
	else:
		Freddy.looking_left_on_specificly_cam_3 = true

func _on_timer_movement_cam_2_timeout() -> void:
	timer_active = false

func _on_minimapa_botones_cam_act() -> void:
	$Cam_1.visible = false
	$Cam_2.visible = false
	$Cam_3.visible = false
	$Cam_4.visible = false
	$Cam_5.visible = false
	$Cam_6.visible = false
	$Cam_7.visible = false
	$Cam_8.visible = false
	$Cam_9.visible = false
	$Cam_10A.visible = false
	$Cam_10B.visible = false
	$Cam_11A.visible = false
	$Cam_11B.visible = false
	if $"../..".camara_activa == 1:
		$Cam_1.visible = true
	if $"../..".camara_activa == 2:
		$Cam_2.visible = true
		
	if $"../..".camara_activa == 3:
		$Cam_3.visible = true
		position.x = ultima_pos_3
		if position.x >= 1440.0 or position.x <= 480.0:
			$Timer_movement_Cam_2.start()
		else:
			$Timer_movement_Cam_2.stop()
		
	if $"../..".camara_activa == 4:
		$Cam_4.visible = true
	if $"../..".camara_activa == 5:
		$Cam_5.visible = true
	if $"../..".camara_activa == 6:
		$Cam_6.visible = true
	if $"../..".camara_activa == 7:
		$Cam_7.visible = true
	if $"../..".camara_activa == 8:
		$Cam_8.visible = true
	if $"../..".camara_activa == 9:
		$Cam_9.visible = true
	if $"../..".camara_activa == 10:
		$Cam_10A.visible = true
	if $"../..".camara_activa == 11:
		$Cam_10B.visible = true
	if $"../..".camara_activa == 12:
		$Cam_11A.visible = true
	if $"../..".camara_activa == 13:
		$Cam_11B.visible = true


func movement_freddy(to, tpath, from, fpath):
	var to_cam: int
	to_cam = get_cam_from_movement_fd(to, tpath)
	
	var from_cam: int
	from_cam = get_cam_from_movement_fd(from, fpath)
	
	emit_signal("cam_act", true, from_cam, to_cam, 0, false)

func get_cam_from_movement_fd(pos, path):
	var cam := 0
	
	if pos == "S":
		cam = 1
	elif pos == "0" or (path == 1 and pos == "1"):
		cam = 2
	elif pos == "T1" or (path == 2 and pos == "1"):
		cam = 3
	elif path == 2 and pos == "2":
		cam = 4
	elif path == 2 and pos == "3":
		cam = 5
	elif path == 1 and pos == "2":
		cam = 7
	elif pos == "T2":
		cam = 9
	elif path == 1 and pos == "3":
		cam = 10
	elif path == 1 and pos == "PI":
		cam = 11
	elif path == 2 and pos == "4":
		cam = 12
	elif path == 2 and pos == "PD":
		cam = 13
	
	return cam


func movement_bonnie(to, from):
	var to_cam: int
	to_cam = get_cam_from_movement_b(to)
	
	var from_cam: int
	from_cam = get_cam_from_movement_b(from)
	
	var extra := 0
	if to == "2" or from == "2":
		extra = 2
	
	emit_signal("cam_act", false, from_cam, to_cam, extra, false)

func get_cam_from_movement_b(pos):
	var cam := 0
	
	if pos == "S":
		cam = 1
	elif pos == "0" or pos == "1":
		cam = 2
	elif pos == "2" or pos == "3":
		cam = 7
	elif pos == "5":
		cam = 8
	elif pos == "4":
		cam = 10
	elif pos == "PI":
		cam = 11
	
	return cam


func movement_chica(to, from):
	var to_cam: int
	to_cam = get_cam_from_movement_c(to)
	
	var from_cam: int
	from_cam = get_cam_from_movement_c(from)
	
	emit_signal("cam_act", false, from_cam, to_cam, 0, false)

func get_cam_from_movement_c(pos):
	var cam := 0
	
	if pos == "S":
		cam = 1
	elif pos == "1":
		cam = 3
	elif pos == "2":
		cam = 4
	elif pos == "3":
		cam = 5
	elif pos == "6":
		cam = 6
	elif pos == "5":
		cam = 9
	elif pos == "4":
		cam = 12
	elif pos == "PD":
		cam = 13
	
	return cam


func movement_foxy(to, troom, from, froom):
	
	if troom == "almacen" and froom == "almacen": # evito que haya estática cuando foxy se desplaza por almacen. Evita confusion
		return
	
	var to_cam: int
	to_cam = get_cam_from_movement_fx(to, troom)
	
	var from_cam: int
	from_cam = get_cam_from_movement_fx(from, froom)
	
	emit_signal("cam_act", false, from_cam, to_cam, 0, false)

func get_cam_from_movement_fx(pos, room):
	var cam := 0 # en el caso de foxy si que es posible
	#room -> 0 (nowhere), main, arcade, pas, entrance, kitchen, almacen, closet, lhall, rhall
	# Duc1, Duc2, Duc3... Duc8
	if (room == "main" and pos < 3) or (room == "Duc3" and pos == 3):
		cam = 2
	elif room == "main" and pos > 2:
		cam = 3
	elif room == "entrance":
		cam = 4
	elif room == "kitchen" or (room == "Duc4" and pos == 4):
		cam = 5
	elif room == "almacen":
		cam = 6
	elif room == "arcade" or (room == "Duc1" and pos == 3) or (room == "Duc3" and pos == 1):
		cam = 7
	elif room == "closet":
		cam = 8
	elif room == "pas" or (room == "Duc5" and pos == 3):
		cam = 9
	elif room == "lhall" and pos == 1:
		cam = 10
	elif (room == "lhall" and pos == 2) or (room == "Duc8" and pos == 2):
		cam = 11
	elif room == "rhall" and pos == 1:
		cam = 12
	elif (room == "rhall" and pos == 2) or (room == "Duc8" and pos == 6):
		cam = 13
	
	return cam
