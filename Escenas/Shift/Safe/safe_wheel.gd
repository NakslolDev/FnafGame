extends Sprite2D

@export var allow_going_back := false
@export var allow_multiple_rotations := false
@export var return_all_rotations := false
@export var cap_speed := 200 # es sin cap_speed
@export var inicial_return_speed := 0


var mouse_in := false
var mouse_pressed := false

var rot_in := 0.0
var grados_mouse: float
var grados_iniciales: float
var grados: float

var rotaciones: int
var next_deg: float

var vel_extra: float

var num_comb: int
var combination = []

func _process(delta: float):
	
	if mouse_pressed:
		
		var grados_mouse_last := grados_mouse
		grados_mouse = calcular_grados(get_viewport().get_mouse_position(), Vector2(960, 540))
		if grados_mouse_last - grados_mouse > 270.0:
			rotaciones += 1
		elif grados_mouse - grados_mouse_last > 270.0:
			rotaciones -= 1
		
		next_deg = (grados_mouse + rotaciones * 360) - grados_iniciales + rot_in
		
		if not allow_multiple_rotations and next_deg > 360:
			next_deg = 360
		
		if next_deg < 0:
			next_deg = 0
		
		if next_deg > rotation_degrees or allow_going_back: # evita que vuelva hacia atras y pone un limite de velocidad
			if next_deg - rotation_degrees > cap_speed * delta and cap_speed != 0:
				rotation_degrees += cap_speed * delta
			elif - next_deg + rotation_degrees > cap_speed * delta and cap_speed != 0:
				rotation_degrees -= cap_speed * delta
			else:
				rotation_degrees = next_deg
		
		if rotation_degrees > (num_comb + 1) * 36:
			@warning_ignore("narrowing_conversion")
			num_comb = rotation_degrees / 36
			$"../Sounds/AudioStreamPlayer".play()
		
		vel_extra = 0

	elif rotation_degrees != 0:
		
		while rotation_degrees > 360 and not return_all_rotations:
			rotation_degrees -= 360
		
		vel_extra += delta * 2
		
		rotation_degrees -= inicial_return_speed * delta + vel_extra
		
		if rotation_degrees < 0:
			rotation_degrees = 0
			if num_comb != 0:
				combination.append(num_comb)
				num_comb = 0
				if combination.size() == 5:
					$"../../Auto-exit_timer".start()
		
		rot_in = rotation_degrees

func calcular_grados(pos, center) -> float:
	var grad
	var rel_pos = pos - center
	if rel_pos.y <= 0:
		grad = rad_to_deg(asin(rel_pos.x/sqrt(rel_pos.x * rel_pos.x + rel_pos.y * rel_pos.y)))
	else: # como el y está cuadrado, no diferencia entre y positivo e y negativo, por lo que hay que hacer este apaño
		grad = 180 - rad_to_deg(asin(rel_pos.x/sqrt(rel_pos.x * rel_pos.x + rel_pos.y * rel_pos.y)))
	return grad + 90 #para evitar los angulos negativos del 2do cuadrante

func _input(event):
	
	if not $"../..".on:
		return
	
	if mouse_in and event.is_action_pressed("Click"):
		mouse_pressed = true
		grados_iniciales = calcular_grados(get_viewport().get_mouse_position(), Vector2(960, 540))
	
	if event.is_action_released("Click"):
		mouse_pressed = false
		rotaciones = 0

func _on_interact_mouse_colision_mouse_entered() -> void:
	mouse_in = true

func _on_interact_mouse_colision_mouse_exited() -> void:
	mouse_in = false
