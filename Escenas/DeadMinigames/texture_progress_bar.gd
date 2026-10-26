extends TextureProgressBar

@export var death_minigame_loader: Node
@export var timer: Timer

var exit_progress: float = 0
var fading := false

const EXIT_SPEED := 0.25
const NOT_EXIT_SPEED := 0.5
const FADE_SPEED := 0.5

func _ready() -> void:
	timer.timeout.connect(_fade)
	_show()

func _show():
	fading = false
	modulate.a = 1.0

func _fade():
	fading = true

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Esc"):
		exit_progress += delta * EXIT_SPEED * min(1,2.2-2*exit_progress)
		if fading: _show()
	else:
		exit_progress -= delta * NOT_EXIT_SPEED
		if not fading and timer.is_stopped(): timer.start()
	exit_progress = clamp(exit_progress,0,1)
	value = snapped(exit_progress,step)

	if exit_progress >= 1.0:
		death_minigame_loader.escape()

	if fading and modulate.a > 0:
		modulate.a = max(0, modulate.a - delta * FADE_SPEED)
