extends Node2D

var pulse_up := true

func _process(delta):
	var insanity: float = Global.insanity
	
	$Static.modulate.a = insanity / 1500.0
	$CircleGradient.modulate.a = insanity / 800.0
	$CircleGradient.scale = Vector2(-insanity/5000.0 + 1, -insanity/5000.0 + 1)
	
	if insanity < 200:
		$Pulse.modulate.a = 0.0
		return
	if insanity > 999:
		pulse_up = true
	if pulse_up:
		if $Pulse.modulate.a < min(insanity / 500.0, 1.0):
			$Pulse.modulate.a += delta * insanity / 1000.0
		else:
			pulse_up = false
	else:
		if $Pulse.modulate.a > 0.0:
			$Pulse.modulate.a -= delta * insanity / 1000.0
		else:
			pulse_up = true


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Click"):
		#if Global.insanity < 1000:
			#Global.insanity += 100
