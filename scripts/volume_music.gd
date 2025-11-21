extends HSlider

func _ready():
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica"))
	value = db_to_linear(db)

func _on_value_changed(value_o: float) -> void:
	# porcentaje de 0.0 a 1.0
	var volumen_db = linear_to_db(value_o)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), volumen_db)
