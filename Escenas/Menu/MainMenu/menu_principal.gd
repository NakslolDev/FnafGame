extends Node2D

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

var tick_stop := false

func _ready():
	pass
	#Global.custom_night_ai = [0, 0, 0, 0] # lo puedo cambiar para que sea persistente o no


func begin_game():
	scene_handler.trans_to_scene(scene_handler.scene.SHIFT)

func custom_night():
	scene_handler.change_to_custom_night()

func options():
	scene_handler.change_to_options()


func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
