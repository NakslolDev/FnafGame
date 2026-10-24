extends Sprite2D

@export var timer: Timer

@export var idle_frames := 2
@export var walking_frames := 2
var walking := false
var walking_count := 0
const WALK_TIME := 0.25
const WALK_SPEED := 2
@export var normal_time: float = 0.5
@export var flip := true
var og_position: Vector2 = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(next_sprite)
	reset()

func next_sprite():
	if walking:
		if frame < vframes - 1:
			frame += 1
		else:
			frame = idle_frames
		if walking_count >= 2:
			walking_count = 0
			if abs(position.x - og_position.x) < 20: position.x -= WALK_SPEED
		else:
			walking_count += 1
	else:
		if frame < idle_frames - 1:
			frame += 1
		else:
			frame = 0
			if flip: flip_h = !flip_h

func start_walk():
	timer.wait_time = WALK_TIME
	flip_h = true
	walking = true
	walking_count = 3
	next_sprite()
	timer.start()

func reset():
	timer.wait_time = normal_time
	flip_h = false
	walking = false
	position = og_position
	timer.start()
