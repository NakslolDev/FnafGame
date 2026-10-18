extends CharacterBody2D

const FALL_SPEED := 150.0
const MAGNET_SPEED := 300.0

var full_position: Vector2

@export var sprite_2d: Sprite2D
@export var area_2d_magnet: Area2D
var player: CharacterBody2D


func _physics_process(delta: float) -> void:
	position = full_position
	# Add the gravity.
	if is_on_floor():
		kill()
	
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

enum Type {NONE, RED, ORANGE, BLUE, YELLOW, SPEED, JUMP, MAGNET, MORE}
var type: Type = Type.NONE

func decide_type(current: int, powerup: bool = false):
	if powerup:
		type = randi_range(Type.SPEED,Type.MORE) as Type
	else:
		if current != Type.NONE and randi_range(0,2) == 0: # me aprobecho de que están en el mismo orden
			type = current as Type
		else:
			type = randi_range(Type.RED, Type.YELLOW) as Type
	_skin()

func _skin():
	if type != Type.NONE:
		sprite_2d.frame = type - 1

func delete():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		collected.emit(type, position, not LASER)
		delete()

signal collected(type: Type, pos: Vector2, laser: bool)

const MAGNET_POWER := 3
func check_magnet():
	if area_2d_magnet.get_overlapping_bodies().has(player):
		return player.power == MAGNET_POWER
	return false

const LASER := true
func _on_laser_hitbox_area_entered(_area: Area2D) -> void:
	collected.emit(type, position, LASER)
	delete()
