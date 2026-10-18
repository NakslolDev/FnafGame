extends Node2D

const SPEED := 2
const SHAKE := 1

@export var laser_blueprint: PackedScene

@export var character: CharacterBody2D
@export var limit_left: Node2D
@export var limit_right: Node2D
@export var timer_move: Timer
@export var stun: Timer
@export var laser_positions_left: Array[Node2D]
@export var laser_positions_right: Array[Node2D]
var shooting_left: bool = false

var shaking: bool = false
var shake_left: bool = false

const MOVE_TIME := 0.5
const SHAKE_TIME := 0.25
func _on_timer_move_timeout() -> void:
	if not shaking:
		if abs(character.position.x - position.x) > SPEED:
			var new_pos: float = position.x + SPEED * sign(character.position.x - position.x)
			if limit_left.position.x < new_pos and new_pos < limit_right.position.x:
				position.x = new_pos 
	elif shaking:
		if shake_left:
			position.x -= SHAKE
		else:
			position.x += SHAKE
		shake_left = !shake_left


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == character:
		character.stop_momentum()
		shaking = true
		timer_move.start(SHAKE_TIME)
		stun.start()

func _on_stun_timeout() -> void:
	shaking = false
	timer_move.start(MOVE_TIME)
	
@export var timer_shot: Timer

func shoot():
	if shaking: return
	var laser: Node2D = laser_blueprint.instantiate()
	if shooting_left: laser.global_position = laser_positions_left.pick_random().global_position
	else: laser.global_position = laser_positions_right.pick_random().global_position
	shooting_left = !shooting_left
	add_sibling(laser)

const shoot_cooldowns := [1.5,1.5,2,2.5,3.5]
func _on_timer_shot_timeout() -> void:
	shoot()
	timer_shot.start(shoot_cooldowns.pick_random())


func start():
	timer_move.start()
	timer_shot.start()

func stop():
	stun.stop()
	timer_move.stop()
	timer_shot.stop()

func stop_shoot():
	timer_shot.stop()
