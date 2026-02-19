extends Node

@export var timer: Timer
@export var general: AudioStreamPlayer
@export var izquierda: spacial_audio
@export var derecha: spacial_audio


var bool_izquierda: bool
var freddy_far: bool
var db_volume: int
var count := 0

func _ready():
	Freddy.movement.connect(_movement_freddy)

func _movement_freddy(pos, path, fpos, fpath): # DE MOMENTO TAMBIEN SE ESCUCHA CUANDO TE ENTRA EN LA OFICINA. SUENA IGUAL QUE CUANDO SE VA... NO SE SI DEJARLO
	if path == 1 or fpath == 1:
		bool_izquierda = true
		if pos == "PI" or fpos == "PI":
			count = randi_range(2, 4)
			freddy_far = false
			timer.start(0.1)
		elif pos == "3" or fpos == "3":
			count = randi_range(2, 4)
			freddy_far = true
			timer.start(0.1)
	
	elif path == 2 or fpath == 2:
		bool_izquierda = false
		if pos == "PD" or fpos == "PD":
			count = randi_range(2, 4)
			freddy_far = false
			timer.start(0.1)
		elif pos == "4" or fpos == "4":
			count = randi_range(2, 4)
			freddy_far = true
			timer.start(0.1)


func _on_timer_timeout() -> void:
	if count == 0:
		return
	count -= 1
	
	if bool_izquierda:
		if not Freddy.door_I_closed and not Global.energia["Luces"]:
			db_volume = -15
			freddy_izquierda()
		elif Freddy.door_I_closed and not Global.energia["Luces"]:
			db_volume = -20
			freddy_izquierda()
		elif not Freddy.door_I_closed and Global.energia["Luces"]:
			db_volume = -20
			freddy_general()
		else:
			return
	else:
		if not Freddy.door_D_closed and not Global.energia["Luces"]:
			db_volume = -15
			freddy_derecha()
		elif Freddy.door_D_closed and not Global.energia["Luces"]:
			db_volume = -20
			freddy_derecha()
		elif not Freddy.door_D_closed and Global.energia["Luces"]:
			db_volume = -20
			freddy_general()
		else:
			return
	
	timer.start(1.0)

func freddy_izquierda():
	if freddy_far:
		db_volume -= 5
	izquierda._volume = db_volume
	izquierda.play()
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "left freddy footsteps: ", db_volume, " db")

func freddy_derecha():
	if freddy_far:
		db_volume -= 5
	derecha._volume = db_volume
	derecha.play()
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "right freddy footsteps: ", db_volume, " db")

func freddy_general():
	if freddy_far:
		db_volume -= 5
	general.volume_db = db_volume - 5
	general.play()
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "freddy footsteps: ", db_volume, " db")
