extends Node2D

@export var textures: Array[Sprite2D]
@export var timer: Timer
@export var actual_noise: AudioStreamPlayer2D

var actual: Sprite2D

func _ready() -> void:
	for texture in textures:
		texture.visible = false
	actual = textures.pick_random()
	actual.visible = true

func act():
	if is_visible_in_tree():
		if timer.is_stopped():
			timer.start()
		if not actual_noise.playing:
			actual_noise.play()
	else:
		timer.stop()
		actual_noise.stop()

func _on_timer_timeout() -> void:
	textures.erase(actual)
	var new: Sprite2D = textures.pick_random()
	textures.append(actual)
	actual.visible = false
	actual = new
	actual.visible = true
