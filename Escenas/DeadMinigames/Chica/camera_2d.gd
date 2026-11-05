extends Camera2D

const VERTICAL_SIZE := 112
const HORIZONTAL_SIZE := 200

@export var character_chica: CharacterBody2D

@export var spawn_down: Node2D
@export var spawn_up: Node2D
@export var spawn_left: Node2D
@export var spawn_right: Node2D
@export var blackground: Sprite2D


var block_signal := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blackground.visible = true


func _on_down_body_entered(body: Node2D) -> void:
	if body != character_chica or block_signal:
		return
	block_signal = true
	position.y += VERTICAL_SIZE
	character_chica.locate_y(spawn_up)
	_unlock()

func _on_up_body_entered(body: Node2D) -> void:
	if body != character_chica or block_signal:
		return
	block_signal = true
	position.y -= VERTICAL_SIZE
	character_chica.locate_y(spawn_down)
	_unlock()

func _on_left_body_entered(body: Node2D) -> void:
	if body != character_chica or block_signal:
		return
	block_signal = true
	position.x -= HORIZONTAL_SIZE
	character_chica.locate_x(spawn_right)
	_unlock()

func _on_right_body_entered(body: Node2D) -> void:
	if body != character_chica or block_signal:
		return
	block_signal = true
	position.x += HORIZONTAL_SIZE
	character_chica.locate_x(spawn_left)
	_unlock()

const WAIT_FRAMES := 2
func _unlock():
	for i in WAIT_FRAMES: await get_tree().physics_frame
	block_signal = false
