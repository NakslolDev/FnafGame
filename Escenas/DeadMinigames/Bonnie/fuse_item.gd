extends CharacterBody2D

const FALL_SPEED := 150.0
const MAGNET_SPEED := 300.0

var full_position: Vector2 = Vector2(-172.0, -68.0)

@export var area_2d_magnet: Area2D
@export var player: CharacterBody2D


func _physics_process(delta: float) -> void:
	position = full_position
	# Add the gravity.
	
	velocity = FALL_SPEED * Vector2.DOWN * delta

	if check_magnet():
		velocity += delta * MAGNET_SPEED * (player.position - position) / position.distance_to(player.position)

	move_and_slide()
	full_position = position
	position = position.round()

func kill():
	queue_free()

func locate_to(pos):
	if pos is Node2D:
		pos = pos.position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	position = pos
	full_position = pos

func delete():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		collected.emit(position)
		delete()

signal collected(pos: Vector2)

const MAGNET_POWER := 3
func check_magnet():
	if area_2d_magnet.get_overlapping_bodies().has(player):
		return player.power == MAGNET_POWER
	return false
