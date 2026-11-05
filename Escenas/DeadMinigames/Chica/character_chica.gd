extends CharacterBody2D

const FRAMES_ANIMATION := 2
const HALT_ADD := 2
const SPEED := 2

var frame_counter: int = 0
var halt: bool = true

@export var sprite_2d: Sprite2D
@export var timer: Timer

var limit_movement: bool = false

func tick() -> void:
	var direction := Input.get_vector("A", "D", "W", "S")
	direction = _unnormalice(direction)

	#position += direction * SPEED
	#velocity = direction * SPEED * 60
	if not move_and_collide(direction * SPEED, true):
		position += direction * SPEED
	elif not move_and_collide(Vector2(direction.x, 0.0) * SPEED, true):
		position += Vector2(direction.x, 0.0) * SPEED
	elif not move_and_collide(Vector2(0.0, direction.y) * SPEED, true):
		position += Vector2(0.0, direction.y) * SPEED

	halt = direction == Vector2.ZERO

	if abs(direction.y) != 0:
		jump_frame = 2
		if sprite_2d.frame == 1: sprite_2d.frame = 2
	else:
		jump_frame = 1
		if sprite_2d.frame == 2: sprite_2d.frame = 1

	if direction.x > 0:
		sprite_2d.flip_h = false
	elif direction.x < 0:
		sprite_2d.flip_h = true

	frame_counter += 1

func _unnormalice(vector: Vector2) -> Vector2:
	if vector.x > 0:
		vector.x = 1
	elif vector.x < 0:
		vector.x = -1

	if vector.y > 0:
		vector.y = 1
	elif vector.y < 0:
		vector.y = -1

	return vector


var jump_frame: int = 1 # 1-> salta, 2 -> no salta
func _on_timer_timeout() -> void:
	tick()
	skin()

func skin():
	if (frame_counter >= FRAMES_ANIMATION + HALT_ADD * int(halt)):
		sprite_2d.frame = 0 if sprite_2d.frame == jump_frame else jump_frame
		frame_counter = 0


func locate_to(pos):
	if pos is Node2D:
		pos = pos.global_position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	global_position = pos

func locate_x(pos):
	if pos is Node2D:
		pos = pos.global_position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	global_position.x = pos.x

func locate_y(pos):
	if pos is Node2D:
		pos = pos.global_position
	if not pos is Vector2:
		push_error("Not a valid position: ", pos)
	global_position.y = pos.y
