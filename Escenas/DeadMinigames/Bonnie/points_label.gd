extends Node2D

@export var kill_timer: Timer
@export var label: Label

const SPEED := -3

var queue_to_die := false

var true_pos: Vector2
func _process(delta: float) -> void:
	true_pos.y += delta * SPEED
	position = true_pos.round()


func _on_kill_timer_timeout() -> void:
	queue_to_die = true

var red: bool = false
func _on_color_timer_timeout() -> void:
	if queue_to_die:
		queue_free()
		return
	if red:
		modulate.b = 1.0
		modulate.g = 1.0
	else:
		modulate.b = 0.25
		modulate.g = 0.25
	red = !red

func start_death_timer(time: float = 0.0):
	if time == 0.0:
		kill_timer.start()
	else:
		kill_timer.start(time)

func set_text(text: String):
	label.text = text

func set_pos(pos: Vector2):
	true_pos = pos
	position = pos
