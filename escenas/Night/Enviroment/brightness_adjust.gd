extends Control

@export var h_slider: HSlider

func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)

func _ready():
	h_slider.value = GlobalWorldEnvironment.environment.adjustment_brightness

func _on_h_slider_value_changed(value: float) -> void:
	GlobalWorldEnvironment.environment.adjustment_brightness = value

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Esc"):
		exit()

func exit():
	Global.screen["brightness"] = GlobalWorldEnvironment.environment.adjustment_brightness
	Global.guardar_configuration()
	if Global.escena_previa == "Opciones":
		get_tree().change_scene_to_file("res://escenas/Menu/Opciones/Opciones.tscn")
	else:
		get_tree().change_scene_to_file("res://escenas/Menu/MainMenu/Menu_Principal.tscn")

func _on_label_2_pressed() -> void:
	exit()
