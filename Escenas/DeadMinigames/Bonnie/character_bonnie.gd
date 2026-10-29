extends CharacterBody2D

const SPEED = 15.0
const JUMP_VELOCITY = -35.0
const GRAVITY := Vector2(0.0, 30.0)

var full_position: Vector2

@export var spawns: Array[Node2D]
@export var sprite_2d: Sprite2D
@export var timer: Timer

enum Pow {NONE, SPEED, JUMP, MAGNET, MORE}
var power: Pow = Pow.NONE
var limit_movement: bool = false

func _physics_process(delta: float) -> void:
	var last_position: Vector2 = position
	position = full_position
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta

	# Handle jump.
	if not (stunned or limit_movement) and (Input.is_action_just_pressed("W") or Input.is_action_just_pressed("Space")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if power == Pow.JUMP: velocity.y *= 1.35

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("A", "D")
	if not stunned: 
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if power == Pow.SPEED: velocity.x *= 1.5
	if limit_movement:
		velocity.x *= 0.5

	move_and_slide()
	full_position = position
	position = position.round()
	
	if last_position != position:
		if not is_on_floor():
			sprite_2d.frame = 3
		elif direction != 0 and timer.is_stopped():
			sprite_2d.frame = 1 if sprite_2d.frame == 0 else 0
			timer.start()
	elif direction == 0 and timer.is_stopped() and is_on_floor():
		sprite_2d.frame = 2

func locate_to(pos):
	if pos is Node2D:
		pos = pos.position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	position = pos
	full_position = pos


func _on_timer_timeout() -> void:
	if is_on_floor() and not Input.get_axis("A", "D"):
		sprite_2d.frame = 2


func stop_momentum():
	velocity = Vector2.ZERO


func _on_laser_hitbox_area_entered(_area: Area2D) -> void:
	stun()

@export var timer_shake: Timer
@export var timer_stun: Timer
var stunned: bool = false
func stun():
	stop_momentum()
	stunned = true
	timer_stun.start()
	timer_shake.start()

func _on_stun_timeout() -> void:
	stunned = false
	timer_shake.stop()

const SHAKE := 1.25
var shake_left: bool = false
func _on_timer_shake_timeout() -> void:
	if stunned:
		if shake_left:
			position.x = round(position.x - SHAKE)
		else:
			position.x = round(position.x + SHAKE)
		full_position.x = position.x
		shake_left = !shake_left
