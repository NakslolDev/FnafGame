extends Node2D

var active := false:
	set = set_active
var _show := 0

func set_active(valor):
	if valor:
		$Alucination_change.start(randf_range(0.1, 0.5))
	else:
		_show = -1
		$Alucination_change.stop()
		$Visions/Bonnie.modulate.a = 0.0
		$Visions/Chica.modulate.a = 0.0
		$Visions/Foxy.modulate.a = 0.0
		$Visions/Freddy.modulate.a = 0.0

func _ready():
	active = false

func _process(_delta):
	if _show > 0:
		_show -= 1
	elif _show == 0:
		$Visions/Bonnie.modulate.a = 0.0
		$Visions/Chica.modulate.a = 0.0
		$Visions/Foxy.modulate.a = 0.0
		$Visions/Freddy.modulate.a = 0.0

func _on_alucination_change_timeout() -> void:
	_show = randi_range(3, 6)
	var rand := randi_range(1, 4)
	
	$Visions/Bonnie.modulate.a = 0.0
	$Visions/Chica.modulate.a = 0.0
	$Visions/Foxy.modulate.a = 0.0
	$Visions/Freddy.modulate.a = 0.0
	
	if rand == 1:
		$Visions/Bonnie.modulate.a = 1.0
	elif rand == 2:
		$Visions/Chica.modulate.a = 1.0
	elif rand == 3:
		$Visions/Foxy.modulate.a = 1.0
	elif rand == 4:
		$Visions/Freddy.modulate.a = 1.0
	
	$Visions.position = Vector2(randi_range(-200, 200), randi_range(-200, 200))
	if _show != -1:
		$Alucination_change.start(randf_range(0.1, 0.5))


func _on_main_game_alucinations(on: bool) -> void:
	active = on


func _on_main_game_on_tick_stop() -> void:
	active = false
	visible = false
