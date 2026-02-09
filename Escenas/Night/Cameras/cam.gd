extends Node2D

var timer_active := false
var girar_izquierda := false
@export var velocidad: float
signal cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int, alucinations: bool)
@export var cameras: Array[Node2D]


func _ready():
	Freddy.connect("movement", Callable(self, "movement_freddy"))
	Bonnie.connect("movement", Callable(self, "movement_bonnie"))
	Chica.connect("movement", Callable(self, "movement_chica"))
	Foxy.connect("movement", Callable(self, "movement_foxy"))
	_on_minimapa_botones_cam_act()
	

func act_cam(cam: int):
	emit_signal("cam_act", false, 0, 0, cam, true)

@export var cams_width: Dictionary = {
	"cam1": 0.0,
	"cam2": 0.0,
	"cam3": 480.0,
	"cam4": 0.0,
	"cam5": 0.0,
	"cam6": 0.0,
	"cam7": 0.0,
	"cam8": 0.0,
	"cam9": 0.0,
	"cam10": 0.0,
	"cam11": 0.0,
	"cam12": 0.0,
	"cam13": 0.0,
}
const INITIAL_X_POS := 960.0
var target_position := INITIAL_X_POS
@export var period := 12.0

func _physics_process(delta: float) -> void:
	
	var active_cam: int = $"../..".camara_activa
	
	if girar_izquierda:
		target_position += velocidad * delta
	else:
		target_position -= velocidad * delta
	
	if (target_position - INITIAL_X_POS) > (velocidad * period * 0.25):
		girar_izquierda = false
	elif (target_position - INITIAL_X_POS) < -(velocidad * period * 0.25):
		girar_izquierda = true
	
	var id_cam := "cam" + str(active_cam)
	
	if target_position > INITIAL_X_POS:
		position.x = min(INITIAL_X_POS + cams_width[id_cam], target_position)
	else:
		position.x = max(INITIAL_X_POS - cams_width[id_cam], target_position)
	
	if position.x <= INITIAL_X_POS:
		Freddy.looking_left_on_specificly_cam_3 = false
	else:
		Freddy.looking_left_on_specificly_cam_3 = true


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
