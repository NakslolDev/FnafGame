extends Node2D

@export var placeholder: Node
const duration_fade := 2.0
const duration_hold := 3.0

signal done

var tween: Tween
var can_skip := false

var hold_elapsed := 0.0
var in_hold := false

func start_animation():
	placeholder.modulate.a = 0.0
	visible = true
	
	tween = create_tween()
	
	tween.tween_property(placeholder, "modulate:a", 1.0, duration_fade)
	tween.tween_callback(func():
		can_skip = true
		in_hold = true
	)

	tween.tween_interval(duration_hold)

	tween.tween_callback(func():
		can_skip = false
		in_hold = false
	)
	tween.tween_property(placeholder, "modulate:a", 0.0, duration_fade)
	tween.finished.connect(func():
		await get_tree().process_frame
		emit_signal("done")
	)

func skip_wait():
	
	var time_to_skip := duration_hold - hold_elapsed
	
	tween.custom_step(time_to_skip)

func _process(delta):
	if in_hold:
		hold_elapsed += delta

func _input(event):
	if can_skip and tween and tween.is_running():
		if event.is_action_pressed("Click") or event.is_action_pressed("interact") or event.is_action_pressed("Esc"):
			skip_wait()
