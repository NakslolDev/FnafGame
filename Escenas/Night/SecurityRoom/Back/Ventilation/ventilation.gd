extends Node

var vent := true
@export var speed := 0.5
@export var pitch := 1.0
@export var volume := 1.0

func _ready():
	Global.connect("energia_actualizada", Callable(self, "act_ventilacion"))
	$VentilationLoop.volume_linear = volume
	$VentilationLoop.play()

func _process(delta):
	if vent:
		if $VentilationLoop.volume_linear < volume:
			$VentilationLoop.volume_linear += speed * delta
		if $VentilationLoop.pitch_scale < pitch:
			$VentilationLoop.pitch_scale += speed * 2 * delta
	else:
		if  $VentilationLoop.volume_linear > speed * delta:
			$VentilationLoop.volume_linear -= speed * delta
		if $VentilationLoop.pitch_scale > speed * 2 * delta:
			$VentilationLoop.pitch_scale -= speed * 2 * delta

func act_ventilacion():
	if Global.energia["Ventilacion"] == true:
		vent = true
	else:
		vent = false
