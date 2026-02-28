extends Control

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

@export var debug := false
@export var debug_panel: Panel

func _input(event):
	if debug_panel.visible:
		return
	if event.is_action_pressed("Esc"):
		salir()

func salir(guardar := true):
	if guardar:
		Global.guardar_configuration()
	else:
		Global.leer_configuration()
	scene_handler.change_to_main_menu()



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
	scene_handler.reset_options_scene()


func _on_reset_pressed() -> void:
	Global.reset_configuration()
	scene_handler.reset_options_scene()

func change_language():
	scene_handler.reset_options_scene()
