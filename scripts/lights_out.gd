extends Node2D

@export var light_out_custom := false
@export_range(0.0, 1.0, 0.01)
var oscuridad: float

func _ready():
	$Oficina_lights_out_Alpha.modulate.a = oscuridad
	Global.connect("energia_actualizada", Callable(self, "energia_act"))
	$Irritating_light.play()

func energia_act():
	if Global.energia["Luces"] or light_out_custom:
		$Oficina_lights_out_Alpha.modulate.a = oscuridad
		if randi_range(0, 1000) == 0:
			$Irritating_light.volume_db = 20.0
		else:
			$Irritating_light.volume_db = 3.0 #arreglar loop
		$Irritating_light.stream_paused = false
	else:
		$Oficina_lights_out_Alpha.modulate.a = 0.5
		$Irritating_light.stream_paused = true
