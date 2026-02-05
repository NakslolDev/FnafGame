extends CanvasLayer

var izquierda: bool
var freddy_far: bool
var db_volume: int
var i_closed := false
var d_closed := false
var count := 0
@export var audio_distancia := 1000
var local_girando: int

func _ready():
	Freddy.connect("movement", Callable(self, "movement_freddy"))

func movement_freddy(pos, path, fpos, fpath): # DE MOMENTO TAMBIEN SE ESCUCHA CUANDO TE ENTRA EN LA OFICINA. SUENA IGUAL QUE CUANDO SE VA... NO SE SI DEJARLO
	if path == 1 or fpath == 1:
		izquierda = true
		if pos == "PI" or fpos == "PI":
			count = randi_range(2, 4)
			freddy_far = false
			$Timer.start(0.1)
		elif pos == "3" or fpos == "3":
			count = randi_range(2, 4)
			freddy_far = true
			$Timer.start(0.1)
	elif path == 2 or fpath == 2:
		izquierda = false
		if pos == "PD" or fpos == "PD":
			count = randi_range(2, 4)
			freddy_far = false
			$Timer.start(0.1)
		elif pos == "4" or fpos == "4":
			count = randi_range(2, 4)
			freddy_far = true
			$Timer.start(0.1)
		

func _on_timer_timeout() -> void:
	if count == 0:
		return
	count -= 1
	
	if izquierda:
		if not i_closed and not Global.energia["Luces"]:
			db_volume = -15
			freddy_izquierda()
		elif i_closed and not Global.energia["Luces"]:
			db_volume = -20
			freddy_izquierda()
		elif not i_closed and Global.energia["Luces"]:
			db_volume = -20
			freddy_general()
		else:
			return
	else:
		if not i_closed and not Global.energia["Luces"]:
			db_volume = -15
			freddy_derecha()
		elif i_closed and not Global.energia["Luces"]:
			db_volume = -20
			freddy_derecha()
		elif not i_closed and Global.energia["Luces"]:
			db_volume = -20
			freddy_general()
		else:
			return
	
	$Timer.start(1.0)

func _process(_delta):
	if local_girando == 0:
		$derecha.position.x = audio_distancia + $"../Oficina".position.x * 2
		$izquierda.position.x = -audio_distancia + $"../Oficina".position.x * 2
	else:
		$derecha.position.x = audio_distancia
		$izquierda.position.x = -audio_distancia

func freddy_izquierda():
	if freddy_far:
		db_volume -= 5
	if local_girando == 0:
		$izquierda.volume_db = db_volume
		$izquierda.play()
	elif local_girando == 3:
		$derecha.volume_db = db_volume
		$derecha.play()
	elif local_girando == 2 or local_girando == -1:
		$General.volume_db = db_volume - 5
		$General.play()
	else:
		$General.volume_db = db_volume - 10
		$General.play()
	print("Volume: ", db_volume)

func freddy_derecha():
	if freddy_far:
		db_volume -= 5
	if local_girando == 0:
		$derecha.volume_db = db_volume
		$derecha.play()
	elif local_girando == 3:
		$izquierda.volume_db = db_volume
		$izquierda.play()
	elif local_girando == 1 or local_girando == -2:
		$General.volume_db = db_volume - 5
		$General.play()
	else:
		$General.volume_db = db_volume - 10
		$General.play()
	print("Volume: ", db_volume)

func freddy_general():
	if freddy_far:
		db_volume -= 5
	$General.volume_db = db_volume - 5
	$General.play()
	print("Volume: ", db_volume)

func _on_oficina_girando_estado(girando: int) -> void:
	local_girando = girando

func _on_puerta_izquierda_state(closed: bool) -> void:
	i_closed = closed

func _on_puerta_derecha_state(closed: bool) -> void:
	d_closed = closed
