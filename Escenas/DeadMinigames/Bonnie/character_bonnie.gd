extends CharacterBody2D

const SPEED = 15.0
const JUMP_VELOCITY = -35.0
const GRAVITY := Vector2(0.0, 30.0)

var full_position: Vector2

@export var spawns: Array[Node2D]
@export var sprite_2d: Sprite2D
@export var timer: Timer

func _ready() -> void:
	_locate_to(spawns[0])

func _physics_process(delta: float) -> void:
	var last_position: Vector2 = position
	position = full_position
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("W") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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

func _locate_to(pos):
	if pos is Node2D:
		pos = pos.position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	position = pos
	full_position = pos


func _on_timer_timeout() -> void:
	if is_on_floor() and not Input.get_axis("A", "D"):
		sprite_2d.frame = 2
