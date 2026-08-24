extends Sprite2D

const animation := {
	"F": [0],
	"F_Walking": [4,0,8,0],
	"B": [2],
	"B_Walking": [6,2,10,2],
	"L": [1],
	"L_Walking": [5,1,9,1],
	"R": [3],
	"R_Walking": [7,3,11,3],
}

var current: String = "F"
var animation_buffer: Array = []
@export var timer: Timer

func play(id: String):
	if id == current: return
	current = id
	animation_buffer.clear()
	_on_timer_timeout()


func _on_timer_timeout() -> void:
	if animation_buffer.is_empty():
		animation_buffer = animation[current].duplicate()
	frame = animation_buffer.pop_front()
	timer.start()
