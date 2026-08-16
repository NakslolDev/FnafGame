extends Node2D

@export var timer: Timer
@export var timer_skip: Timer

const MINIMUM_DURATION := 4.0
const DURATION_HOLD := 8.0

signal done
signal done_and_exit

var can_skip := false

func start_animation():
	visible = true
	can_skip = false
	
	timer.start(DURATION_HOLD)
	timer_skip.start(MINIMUM_DURATION)

func _on_timer_timeout() -> void:
	can_skip = false
	done.emit()

func _on_timer_skip_timeout() -> void:
	can_skip = true

func _input(event):
	if not visible or not can_skip:
		return
	
	if event.is_action_pressed("Click") or event.is_action_pressed("interact"):
		timer.stop()
		done.emit()
	if event.is_action_pressed("Esc"):
		timer.stop()
		done_and_exit.emit()
