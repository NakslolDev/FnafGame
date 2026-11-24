extends Node2D

@export var character_chica: CharacterBody2D
@export var walk := 10
@export var walk_direction: Vector2 = Vector2.RIGHT
@export var timer: Timer
@export var foxy: Sprite2D
@export var bonnie_kid: Sprite2D

var walking := false
var walking_count := 0
const WALK_TIME := 0.25
const WALK_SPEED := 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(next_sprite)
	character_chica.teleported.connect(delete)

func next_sprite():
	next_sprite_foxy()
	next_sprite_bonnie_kid()
	if walking_count >= 2:
		walking_count = 0
		walk += 1
		foxy.position += walk_direction * WALK_SPEED
		bonnie_kid.position += walk_direction * WALK_SPEED
	else:
		walking_count += 1

func next_sprite_foxy():
	if foxy.frame < foxy.vframes - 1:
		foxy.frame += 1
	else:
		foxy.frame = 1

func next_sprite_bonnie_kid():
	if bonnie_kid.frame < bonnie_kid.hframes - 2:
		bonnie_kid.frame += 1
	else:
		bonnie_kid.frame = 0

func start_walk():
	timer.wait_time = WALK_TIME
	walking = true
	walking_count = 3
	#next_sprite()
	timer.start()


func _on_start_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	start_walk()

func delete():
	if walking: queue_free()
