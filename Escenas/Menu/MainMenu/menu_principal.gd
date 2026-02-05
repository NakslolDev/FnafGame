extends Node2D

var game_exist := false
var noche_menu := 1

@export var transicion := 3.0
var transicionando_out: bool
var transicionando_in: bool

func _ready():
	game_exist = FileAccess.file_exists("user://partida.json")
	Global.eliminar_partida_provisional()
	if Global.debug["game_state"]["override"]:
		noche_menu = Global.debug["game_state"]["night"]
	elif Global.noche != -1:
		noche_menu = Global.noche
	if Global.escena_previa != "Opciones" and Global.escena_previa != "Custom_Night":
		transicionando_in = true
		$Transicion.modulate.a = 1.0
	else:
		$Transicion.modulate.a = 0.0
	Global.custom_night_ai = [0, 0, 0, 0]
	$Play_Buttons.act_selected()


func _process(delta):
	if transicionando_out:
		$Transicion.modulate.a += delta / transicion
		if $Transicion.modulate.a >= 1.0:
			$Transicion.modulate.a = 1.0
			transicionando_out = false
			begin_game()
	if transicionando_in:
		$Transicion.modulate.a -= delta / transicion
		if $Transicion.modulate.a <= 0.0:
			$Transicion.modulate.a = 0.0
			transicionando_in = false

func transition_to_play(): # como no hay ningun otro caso de transicion, no tengo que distinguir
	transicionando_in = false
	transicionando_out = true

func begin_game():
	Global.escena_previa = "Menu_Principal"
	Global.m_entering = true
	Global.minigame_starts()
	get_tree().change_scene_to_file("res://escenas/minigame.tscn") #actualizar



func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
