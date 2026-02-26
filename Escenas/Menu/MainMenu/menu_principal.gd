extends Node2D

var game_exist := false
var noche_menu := 1

@export var transicion: Sprite2D
const TRANSITION_TIME := 3.0

func _ready():
	game_exist = FileAccess.file_exists("user://partida.json")
	Global.eliminar_partida_provisional()
	if Global.debug["game_state"]["override"]:
		noche_menu = Global.debug["game_state"]["night"]
	elif Global.noche != -1:
		noche_menu = Global.noche
	if Global.escena_previa != "Opciones" and Global.escena_previa != "Custom_Night":
		_trans_in()
	else:
		transicion.modulate.a = 0.0
	#Global.custom_night_ai = [0, 0, 0, 0]

func _trans_in():
	transicion.modulate.a = 1.0
	var tween := create_tween()
	tween.tween_property(
		transicion, "modulate:a", 0.0, TRANSITION_TIME
	)

func transition_to_play():
	var time = TRANSITION_TIME * (1.0 - transicion.modulate.a)
	var tween := create_tween()
	tween.tween_property(
		transicion, "modulate:a", 1.0, time
	)
	tween.finished.connect(
		begin_game
	)


func begin_game():
	Global.escena_previa = "Menu_Principal"
	Global.m_entering = true
	Global.minigame_starts()
	get_tree().change_scene_to_file("res://Escenas/Shift/minigame.tscn") #actualizar


func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
