extends Node2D

@export var transicion := 3
var transicionando_out: bool
var transicionando_in: bool

func _ready():
	if Global.escena_previa != "Menu_Principal":
		transicionando_in = true
		$Transicion.modulate.a = 1.0
	else:
		$Transicion.modulate.a = 0.0

func _process(delta):
	if transicionando_out:
		$Transicion.modulate.a += delta / transicion
		if $Transicion.modulate.a >= 1.0:
			$Transicion.modulate.a = 1.0
			transicionando_out = false
			Global.escena_previa = "Custom_Night"
			Global.noche = 0
			get_tree().change_scene_to_file("res://Escenas/Night/Main_Game.tscn") #actualizar
	if transicionando_in:
		$Transicion.modulate.a -= delta / transicion
		if $Transicion.modulate.a <= 0.0:
			$Transicion.modulate.a = 0.0
			transicionando_in = false

func transition_to_play(): # como no hay ningun otro caso de transicion, no tengo que distinguir
	transicionando_in = false
	transicionando_out = true


func get_text(id: String):
	return Global.get_csv_value_id(Global.text_CSV_name, id, Global.language)
