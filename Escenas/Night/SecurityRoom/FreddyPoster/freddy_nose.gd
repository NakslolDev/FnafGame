extends Node2D

var cam_warp := false
signal Freddy_Nose_Touch()
signal Freddy_Nose_Entered_Switch()

func _process(delta):
	if cam_warp and $Doit.pitch_scale > 0.05:
		$Doit.pitch_scale -= 0.2 * delta

func _on_click():
	if cam_warp:
		$Doit.pitch_scale = randf_range(0.5, 0.8)
		$Doit.play(0.05)
	else:
		$Doit.pitch_scale = 1.0
		$Doit.play()
	emit_signal("Freddy_Nose_Touch")


func _on_area_2d_mouse_entered() -> void:
	emit_signal("Freddy_Nose_Entered_Switch")

func _on_area_2d_mouse_exited() -> void:
	emit_signal("Freddy_Nose_Entered_Switch")
