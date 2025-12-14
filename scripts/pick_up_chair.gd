extends Node2D

func switch_up_down():
	if $Pick_up.scale != Vector2.ZERO:
		$Pick_up.scale = Vector2.ZERO
		$Pick_down.scale = Vector2(1.7, 1.7)
	else:
		$Pick_up.scale = Vector2(1.7, 1.7)
		$Pick_down.scale = Vector2.ZERO
