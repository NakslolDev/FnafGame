extends Sprite2D

@export var transicion := 3.0

func _process(delta):
	if $"../..".transition_out:
		if modulate.a < 1.0:
			modulate.a += delta / transicion
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Text"), 1 - modulate.a)
			# baja el volumen al texto progresivamente
		else:
			$"../..".done_trans()
	else:
		if modulate.a > 0.0:
			modulate.a -= delta / transicion
