extends Sprite2D

var disapier := false

func _ready():
	$".".modulate.a = 1.0
	$Timer.start()

func _process(delta):
	if disapier and $".".modulate.a > 0.0:
		$".".modulate.a -= delta

func act(cams_up: bool):
	if cams_up:
		$".".modulate.a = 0.0

func _on_timer_timeout() -> void:
	disapier = true

func _on_oficina_girando_estado(girando: int) -> void:
	if girando != 0:
		disapier = true
