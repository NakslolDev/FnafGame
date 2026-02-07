extends Control

@export var debug := false

func _input(event):
	if $Debug_panel.visible:
		return
	if event.is_action_pressed("Esc"):
		salir()

func salir(guardar := true):
	Global.escena_previa = "Opciones"
	if guardar:
		Global.guardar_configuration()
	else:
		Global.leer_configuration()
	get_tree().change_scene_to_file("res://Escenas/Menu/MainMenu/Menu_Principal.tscn") #actualizar



func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)


func _on_save_pressed() -> void:
	Global.guardar_configuration()


func _on_save_exit_pressed() -> void:
	Global.guardar_configuration()
	salir()


func _on_exit_pressed() -> void:
	salir(false)


func _on_undo_pressed() -> void:
	Global.leer_configuration()
	get_tree().change_scene_to_file("res://Escenas/Menu/Opciones/Opciones.tscn") #actualizar


func _on_reset_pressed() -> void:
	Global.reset_configuration()
	get_tree().change_scene_to_file("res://Escenas/Menu/Opciones/Opciones.tscn") #actualizar


func _on_brightness_pressed() -> void:
	Global.escena_previa = "Opciones"
	GlobalWorldEnvironment.load_brightness_slider()
