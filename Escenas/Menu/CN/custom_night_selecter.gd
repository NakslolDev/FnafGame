extends Node2D

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)

func start_night():
	scene_handler.trans_to_scene(scene_handler.scene.NIGHT)

func go_back():
	scene_handler.change_to_main_menu()
