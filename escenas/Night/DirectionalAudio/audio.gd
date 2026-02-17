extends AudioStreamPlayer2D
class_name spacial_audio

const CENTER_COORDS := Vector2(1080.0/2.0, 1920.0/2.0)

enum pos {CENTER, SOFT_LEFT, LEFT, FAR_LEFT, SOFT_RIGHT, RIGHT, FAR_RIGHT, CUSTOM}
@export var x_position: pos = pos.CENTER

@export var custom_x_pos := 0

func _ready():
	_first_locate()
	
	play()

func _first_locate():
	position = CENTER_COORDS
	
	match x_position:
		pos.SOFT_LEFT:
			position.x -= CENTER_COORDS.x / 2.0
		pos.LEFT:
			position.x -= CENTER_COORDS.x
		pos.FAR_LEFT:
			position.x -= CENTER_COORDS.x * 2
		pos.SOFT_RIGHT:
			position.x += CENTER_COORDS.x / 2.0
		pos.RIGHT:
			position.x += CENTER_COORDS.x
		pos.FAR_RIGHT:
			position.x += CENTER_COORDS.x * 2
		pos.CUSTOM:
			position.x += custom_x_pos
