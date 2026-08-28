extends Node2D

@export var camera_2d: Camera2D
@export var sprites: Node2D

var initial_pos: Vector2

func _ready() -> void:
	initial_pos = sprites.global_position

const FACTOR := 0.1
func _process(_delta: float) -> void:
	sprites.global_position = initial_pos + (camera_2d.global_position - initial_pos) * FACTOR
