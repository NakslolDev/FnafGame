extends Sprite2D

signal done_fade_in
signal done_fade_out

const DEFAULT_TRANSITION_TIME := 2.0

var _tween: Tween

func _ready():
	visible = false

func _kill_tween():
	if _tween != null and _tween.is_running():
		_tween.kill()
	_tween = null

func fade_in(custom_time: float = DEFAULT_TRANSITION_TIME):
	visible = true
	
	var real_time = max(custom_time * (1 - modulate.a), 0.001)
	
	_kill_tween()
	_tween = create_tween()
	
	_tween.tween_property(
		self, "modulate:a", 1.0, real_time
	)
	
	await _tween.finished
	done_fade_in.emit()

func fade_out(custom_time: float = DEFAULT_TRANSITION_TIME):
	var real_time = max(custom_time * modulate.a, 0.001)
	
	_kill_tween()
	_tween = create_tween()
	
	_tween.tween_property(
		self, "modulate:a", 0.0, real_time
	)
	
	await _tween.finished
	visible = false
	done_fade_out.emit()

func instant_fade_in():
	_kill_tween()
	visible = true
	modulate.a = 1.0
	done_fade_in.emit()

func instant_fade_out():
	_kill_tween()
	visible = false
	modulate.a = 0.0
	done_fade_out.emit()
