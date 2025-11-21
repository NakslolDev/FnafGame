extends Node2D

var mouse_in := false

func _ready():
	$DuctSelecterHl.modulate.a = 0.0
	$CamSelecterHl.modulate.a = 0.0
	act_button()

func act_button():
	if $"../..".ductos:
		$CamSelecterHl.modulate.a = 0.0
		$CamSelecter.modulate.a = 0.0
		$DuctSelecter.modulate.a = 1.0
		if mouse_in:
			$DuctSelecterHl.modulate.a = 1.0
		else:
			$DuctSelecterHl.modulate.a = 0.0
	else:
		$DuctSelecterHl.modulate.a = 0.0
		$CamSelecter.modulate.a = 1.0
		$DuctSelecter.modulate.a = 0.0
		if mouse_in:
			$CamSelecterHl.modulate.a = 1.0
		else:
			$CamSelecterHl.modulate.a = 0.0

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$"../..".ductos = !$"../..".ductos
		act_button()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	act_button()

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	act_button()
