extends Node2D

const NORMAL_ALPHA := 0.15

var rand_pos: Vector2
var last_pos: Vector2
var alpha := NORMAL_ALPHA
var fade_speed := 0.4
var override_freddy_static := false

@export var noise: Sprite2D
@export var static_speed: Timer
@export var static_time: Timer
@export var _static: AudioStreamPlayer
@export var cam_root: Node2D

const UP_STATIC_WHEN_CHANGING_CAMS := 0.1
const UP_STATIC_WHEN_ANIMATRONIC_MOVEMENT := 0.7
const UP_STATIC_WHEN_FREDDY_MOVEMENT := 1.2

const FADE_FAST := true
const FADE_SLOW := false

const FADE_FAST_SPEED := 0.8
const FADE_SLOW_SPEED := 0.4

func _ready():
	static_speed.start()

func _process(delta):
	if Freddy.cam_look_count >= 20 and not override_freddy_static: # es un poco raro, pero hace una comparacion entre lo que le queda a cam count del maximo y el sonido del máximo. Asi, en vez de subir la estática, sube un limite inferior
		if _static.volume_db + 25 < Freddy.cam_look_count - 20:
			noise.modulate.a += fade_speed * delta / 3.0
			_static.volume_db += fade_speed * 10 * delta / 3.0
			return
	if abs(alpha - noise.modulate.a) < 0.01:
		return
	if alpha > noise.modulate.a:
		noise.modulate.a = alpha
		_static.volume_db = -15
	elif alpha < noise.modulate.a:
		noise.modulate.a -= fade_speed * delta
		_static.volume_db -= fade_speed * 10 * delta # el 10 viene de el máximo -15 menos el minimo -25

func up_static(time: float, fast: bool):
	override_freddy_static = true
	if static_time.time_left > time: #evita que se pueda reducir el tiempo de estatica, pero si aumentar
		return
	alpha = 1.0
	static_time.start(time)
	if fast:
		fade_speed = FADE_FAST_SPEED
	else:
		fade_speed = FADE_SLOW_SPEED

func _on_static_time_timeout() -> void:
	override_freddy_static = false
	alpha = NORMAL_ALPHA

func _on_static_speed_timeout() -> void:
	while (last_pos - rand_pos).length_squared() < 500:
		rand_pos.x = randf_range(480, 1440)
		rand_pos.y = randf_range(270, 810)
		noise.position = rand_pos
	last_pos = rand_pos


func _on_minimapa_botones_cam_act() -> void:
	up_static(UP_STATIC_WHEN_CHANGING_CAMS, FADE_FAST)

func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int) -> void:
	if freddy:
		up_static(UP_STATIC_WHEN_FREDDY_MOVEMENT, FADE_SLOW)
	elif Global.energia["Camaras"] and (cam_root.camara_activa == local_from or cam_root.camara_activa == local_to or cam_root.camara_activa == local_extra):
		up_static(UP_STATIC_WHEN_ANIMATRONIC_MOVEMENT, FADE_SLOW)
