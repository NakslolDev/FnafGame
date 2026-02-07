extends WorldEnvironment

@export var bright_slider: PackedScene

func load_brightness_slider():
	get_tree().change_scene_to_file("res://escenas/Night/Enviroment/brightness_adjust.tscn")
