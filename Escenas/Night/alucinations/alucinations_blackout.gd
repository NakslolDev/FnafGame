extends Node2D

var pulse_up := true

func _ready():
	$Static.modulate.a = 0.0
	$Pulse.modulate.a = 0.0
	$CircleGradient.modulate.a = 0.0

func _process(delta):
	var insanity: float = Global.insanity
	
	$Static.modulate.a = max(insanity,0) / 1500.0
	$CircleGradient.modulate.a = insanity / 800.0
	$CircleGradient.scale = Vector2(-max(insanity,0)/5000.0 + 1, -max(insanity,0)/5000.0 + 1)
	
	if insanity < 200:
		if $Pulse.modulate.a > 0.0:
			$Pulse.modulate.a -= delta * abs(insanity) / 1500.0
		return
	if insanity > 999:
		pulse_up = true
	if pulse_up:
		if $Pulse.modulate.a < min(((200.0 / 1500.0) + (insanity - 200.0) * (1.0 - 200.0 / 1500.0) / 300.0), 1.0):
			$Pulse.modulate.a += delta * (insanity-200) / 800.0
		else:
			pulse_up = false
	else:
		if $Pulse.modulate.a > 0.0:
			$Pulse.modulate.a -= delta * (insanity-200) / 800.0
		else:
			pulse_up = true
