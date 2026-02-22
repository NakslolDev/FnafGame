extends AudioStreamPlayer2D
class_name spacial_audio

const CENTER_COORDS := Vector2.ZERO #Vector2(1080.0/2.0, 1920.0/2.0)
const DISPLACEMENT := 1080.0

const OFFICE_WITH := 3120.0

var _local_deg

enum pos {CENTER, SOFT_LEFT, LEFT, FAR_LEFT, SOFT_RIGHT, RIGHT, FAR_RIGHT, BEHIND, CUSTOM}
@export var x_position: pos = pos.CENTER

@export var _custom_degrees := 0

@export var _volume := 0.0
@export var _lower_db := 5.0

@export_range(0.0, 1.0) var concentration: float = 1.0

func _ready():
	
	panning_strength = 3.0
	attenuation = 0.0
	
	_change_pos(0.0) # al principio tu posicion es 0


func _starting_pos_displacement() -> float:
	
	var _degrees: float
	
	match x_position:
		pos.CENTER:
			_degrees = 0.0
		pos.SOFT_LEFT:
			_degrees = -30.0
		pos.LEFT:
			_degrees = -60.0
		pos.FAR_LEFT:
			_degrees = -90.0
		pos.SOFT_RIGHT:
			_degrees = 30.0
		pos.RIGHT:
			_degrees = 60.0
		pos.FAR_RIGHT:
			_degrees = 90.0
		pos.BEHIND:
			_degrees = 180.0
		pos.CUSTOM:
			_degrees = _custom_degrees
	
	return _degrees

func _position_degrees():
	
	position = CENTER_COORDS
	
	position.x += DISPLACEMENT * concentration * sin(deg_to_rad(_local_deg))

func _x_to_deg(_x_pos) -> float:
	var _deg: float
	_deg = _x_pos * (180.0 / OFFICE_WITH)
	return _deg

func change_volume():
	volume_db = _volume - _lower_db * sin(deg_to_rad(abs(_local_deg) / 2.0))


func _change_pos(_x_pos: float):
	
	_local_deg = _starting_pos_displacement() + _x_to_deg(_x_pos)
	
	_position_degrees()
	change_volume()
