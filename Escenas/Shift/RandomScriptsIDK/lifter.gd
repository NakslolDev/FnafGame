extends Area2D

enum dir {LEFT, RIGHT, UP, DOWN}
@export var direction: dir = dir.LEFT
@export var unit_length: int = 4
@export var unit_lift: int = 2
const UNIT_PIXEL := 4

@export var character_minigame: CharacterBody2D

var player_in: bool = false

func _ready() -> void:
	body_entered.connect(player_enter)
	body_exited.connect(player_exit)

func player_enter(body: Node2D):
	if body == character_minigame:
		player_in = true

func player_exit(body: Node2D):
	if body == character_minigame:
		player_in = false
		match direction:
			dir.LEFT:
				if character_minigame.global_position.x > global_position.x:
					character_minigame.set_height(unit_lift*UNIT_PIXEL)
				else:
					character_minigame.set_height(0)
			dir.RIGHT:
				if character_minigame.global_position.x < global_position.x:
					character_minigame.set_height(unit_lift*UNIT_PIXEL)
				else:
					character_minigame.set_height(0)
			dir.UP:
				if character_minigame.global_position.y > global_position.y:
					character_minigame.set_height(unit_lift*UNIT_PIXEL)
				else:
					character_minigame.set_height(0)
			dir.DOWN:
				if character_minigame.global_position.y < global_position.y:
					character_minigame.set_height(unit_lift*UNIT_PIXEL)
				else:
					character_minigame.set_height(0)

func _process(_delta: float) -> void:
	if player_in:
		match direction:
			dir.LEFT:
				character_minigame.set_height(
				clampf((character_minigame.global_position.x - global_position.x) / (unit_length * UNIT_PIXEL) + 0.5 ,0,1) * unit_lift * UNIT_PIXEL
				)
			dir.RIGHT:
				character_minigame.set_height(
				clampf((global_position.x - character_minigame.global_position.x) / (unit_length * UNIT_PIXEL) + 0.5 ,0,1) * unit_lift * UNIT_PIXEL
				)
			dir.UP:
				character_minigame.set_height(
				clampf((character_minigame.global_position.y - global_position.y) / (unit_length * UNIT_PIXEL) + 0.5 ,0,1) * unit_lift * UNIT_PIXEL
				)
			dir.DOWN:
				character_minigame.set_height(
				clampf((global_position.y - character_minigame.global_position.y) / (unit_length * UNIT_PIXEL) + 0.5 ,0,1) * unit_lift * UNIT_PIXEL
				)
