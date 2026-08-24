extends Node2D

@export var timer: Timer
@export var character_minigame: CharacterBody2D
@export var skins: Node2D

@export var flashlight: Node2D

var time: float
var distance: int

var direction_s: String # solamente para skin
var waking: bool
var colided := false

func _ready():
	distance = character_minigame.step
	time = 1.0 / character_minigame.speed
	if Global.m_entering:
		flashlight.rotation = atan2(-Vector2.DOWN.y, -Vector2.DOWN.x)
		set_flashlight(Vector2.DOWN)
	else:
		flashlight.visible = false

func _physics_process(_delta):
	get_direction_s(Input.is_action_pressed("W"), Input.is_action_pressed("A"), Input.is_action_pressed("S"), Input.is_action_pressed("D")) # inportante la diferencia de event e Input. event es solo el primer frame. Input es constante
	skins.act_animation(waking, direction_s, colided)

func get_direction_s(w: bool, a: bool, s: bool, d: bool):
	if ((w != s) != (a != d)): # != es xor. Permite el paso si solo una tecla está siendo presionada o 3 (2 opuestas, se cancelas)
		if w and not s:
			direction_s = "B"
		elif s and not w:
			direction_s = "F"
		elif a and not d:
			direction_s = "L"
		elif d and not a:
			direction_s = "R"
	waking = false
	if ((w != s) or (a != d)):
		waking = true
		set_flashlight(Vector2(int(d) - int(a), int(s) - int(w)).normalized())

func _input(event):
	if not (event.is_action_pressed("D") or event.is_action_pressed("A") or event.is_action_pressed("W") or event.is_action_pressed("S")):
		return
	
	if timer.is_stopped():
		move_step()
		timer.start(time)
		

func _on_timer_timeout():
	if not (Input.is_action_pressed("A") or Input.is_action_pressed("D") or Input.is_action_pressed("S") or Input.is_action_pressed("W")):
		timer.stop()
	else:
		if Input.is_action_pressed("Shift"):
			timer.start(time/1.0)
		else:
			timer.start(time)
		move_step()


func move_step():
	
	if character_minigame.freeze:
		return
	
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("D"):
		dir.x += 1
	if Input.is_action_pressed("A"):
		dir.x += -1
	if Input.is_action_pressed("W"):
		dir.y += -1
	if Input.is_action_pressed("S"):
		dir.y += 1
	
	if dir == Vector2.ZERO:
		return
	
	var parent = get_parent() as CharacterBody2D
	if parent == null:
		return
	
	# movimiento deseado
	var motion = dir * distance
	if Input.is_action_pressed("Shift"):
		motion *= character_minigame.run_mult
	
	if dir.x != 0.0 and dir.y != 0.0:  # Frenamos movimiento diagonal
		if Input.is_action_pressed("Shift"):
			motion *= 0.8 # Esta redondeada hacia arriba un poco
		else:
			motion *= 0.9
	
	# Intentar movimiento completo
	var collision = parent.move_and_collide(motion)
	if collision:
		# Si hay choque → probar ejes por separado
		# probar eje X
		var collision_x = parent.move_and_collide(Vector2(dir.x * distance, 0))
		# probar eje Y
		var collision_y = parent.move_and_collide(Vector2(0, dir.y * distance))
		
		if dir.x != 0 and dir.y != 0:
			if collision_x and collision_y:
				colided = true
			else:
				colided = false
		elif dir.x != 0:
			if collision_x:
				colided = true
			else:
				colided = false
		elif dir.y != 0:
			if collision_y:
				colided = true
			else:
				colided = false
	
	else:
		colided = false  # movimiento realizado, no hay choque

const FLASHLIGHT_DISPLACEMENT := 6.0
const FLASHLIGHT_SMOOTHNESS := 15.0

var flashlight_target_rotation := 0.0

func set_flashlight(direction: Vector2):
	if not flashlight.visible: return
	flashlight_target_rotation = atan2(-direction.y, -direction.x)

const FLASHLIGHT_CENTER := Vector2(0.0, -26.667)
const FLASHLIGHT_CENTERED_CENTER := Vector2(0.0, 20)
@export var flashlight_lights: Array[PointLight2D]
@export var flashlight_centered: PointLight2D
func _process(delta):
	if character_minigame.freeze or not flashlight.visible:
		return
	var weight := 1.0 - exp(-FLASHLIGHT_SMOOTHNESS * delta)
	flashlight.rotation = lerp_angle(flashlight.rotation, flashlight_target_rotation, weight)
	for light in flashlight_lights: light.offset = FLASHLIGHT_CENTER.rotated(-flashlight.rotation)
	flashlight_centered.offset = FLASHLIGHT_CENTERED_CENTER.rotated(-flashlight.rotation)
	for light in flashlight_lights: light.position = FLASHLIGHT_CENTER.rotated(-flashlight.rotation) * -0.3
	flashlight_centered.position = FLASHLIGHT_CENTERED_CENTER.rotated(-flashlight.rotation) * -0.3
