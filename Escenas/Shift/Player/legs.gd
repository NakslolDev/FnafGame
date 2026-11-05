extends Node2D

@export var character_minigame: CharacterBody2D
@export var skins: Node2D

@export var flashlight: Node2D

var direction_s: String # solamente para skin
var waking: bool
var colided := false

func _ready():
	if Global.m_entering:
		flashlight.rotation = atan2(-Vector2.DOWN.y, -Vector2.DOWN.x)
		set_flashlight(Vector2.DOWN)
	else:
		flashlight.visible = false

func _physics_process(_delta):
	get_direction_s(Input.is_action_pressed("W"), Input.is_action_pressed("A"), Input.is_action_pressed("S"), Input.is_action_pressed("D")) # importante la diferencia de event e Input. event es solo el primer frame. Input es constante
	move_step()
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

func move_step():
	if character_minigame.freeze or character_minigame == null:
		if character_minigame:
			character_minigame.velocity = Vector2.ZERO
		colided = false
		return

	# Sin normalizar: en diagonal el vector mide 1.41
	var dir := Vector2(Input.get_axis("A", "D"), Input.get_axis("W", "S"))

	if dir == Vector2.ZERO:
		character_minigame.velocity = Vector2.ZERO
		character_minigame.move_and_slide()
		colided = false
		return

	var running := Input.is_action_pressed("Shift")

	var speed_now: float = character_minigame.speed
	if running:
		speed_now *= character_minigame.run_mult

	var velocity_target := dir * speed_now

	if dir.x != 0.0 and dir.y != 0.0: # Frenamos movimiento diagonal
		if running:
			velocity_target *= 0.8 # Esta redondeada hacia arriba un poco
		else:
			velocity_target *= 0.9

	character_minigame.velocity = velocity_target
	character_minigame.move_and_slide()

	# "colided" solo si te frenas casi del todo (choque frontal), no al deslizar
	colided = character_minigame.get_real_velocity().length() < velocity_target.length() * 0.2

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
