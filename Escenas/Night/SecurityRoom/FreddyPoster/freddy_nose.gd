extends Node2D

var cam_warp := false
@export var doit: AudioStreamPlayer


func _process(delta):
	if cam_warp and doit.pitch_scale > 0.05:
		doit.pitch_scale -= 0.2 * delta

func _on_click():
	if cam_warp:
		doit.pitch_scale = randf_range(0.5, 0.8)
		doit.play(0.05)
	else:
		doit.pitch_scale = 1.0
		doit.play()
