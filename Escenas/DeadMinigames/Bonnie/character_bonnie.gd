extends CharacterBody2D

@export var tick: Timer

const SPEED = 15.0
const JUMP_VELOCITY = -30.0
const GRAVITY := Vector2(0.0, 15.0)

var full_position: Vector2 = position

func _ready() -> void:
	pass
	#tick.timeout.connect(_physics_tick)

func _physics_process(delta: float) -> void:
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
