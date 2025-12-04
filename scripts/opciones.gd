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
	get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn")



func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
