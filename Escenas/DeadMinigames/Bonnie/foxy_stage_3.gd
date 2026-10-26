extends Sprite2D

@export var timer: Timer
@export var character_bonnie: CharacterBody2D

@export var walking_frames := 2
var walking_count := 0
const WALK_TIME := 0.1
const WALK_SPEED := 3
var og_position: Vector2 = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(next_sprite)
	reset()

func next_sprite():
	if frame < vframes - 1:
		frame += 1
	else:
		frame = 0
	if walking_count >= 0:
		walking_count = 0
		position.x += WALK_SPEED
	else:
		walking_count += 1

func go():
	timer.wait_time = WALK_TIME
	walking_count = 3
	next_sprite()
	timer.start()

func reset():
	flip_h = false
	position = og_position

signal dead
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == character_bonnie: dead.emit()
