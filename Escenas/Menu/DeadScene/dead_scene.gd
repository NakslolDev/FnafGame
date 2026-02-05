extends Node2D

var type := 0

@export var transicion := 3
var transicionando_out: bool
var transicionando_in: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") or event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space") or event.is_action_pressed("interact"):
		transition_to_menu()

func _ready():
	transicionando_in = true
	type = Global.dead_scene_type
	act_sprites()
	$Advice.act_advice(type)

func act_sprites():
	$Imagen/Fan.visible = false
	$Imagen/Bonnie.visible = false
	$Imagen/Chica.visible = false
	$Imagen/Freddy.visible = false
	$Imagen/Foxy.visible = false
	
	if type == 0:
		$Imagen/Fan.visible = true
	if type == 1:
		$Imagen/Bonnie.visible = true
	if type == 2:
		$Imagen/Chica.visible = true
	if type == 3:
		$Imagen/Freddy.visible = true
	if type == 4:
		$Imagen/Foxy.visible = true

func _process(delta):
	if transicionando_out:
		$Transicion.modulate.a += delta / transicion
		if $Transicion.modulate.a >= 1.0:
			$Transicion.modulate.a = 1.0
			transicionando_out = false
			Global.escena_previa = "Dead_scene"
			if Global.noche == 0:
				if Global.misc["When_dead_go_to"] == "night":
					get_tree().change_scene_to_file("res://Escenas/Night/Main_Game.tscn") #actualizar
				else:
					get_tree().change_scene_to_file("res://Escenas/Menu/CN/custom_night_selecter.tscn") #actualizar
			else:
				if Global.misc["When_dead_go_to"] == "night":
					get_tree().change_scene_to_file("res://Escenas/Night/Main_Game.tscn") #actualizar
				elif Global.misc["When_dead_go_to"] == "shift":
					Global.m_entering = true
					Global.minigame_starts()
					get_tree().change_scene_to_file("res://Escenas/Shift/minigame.tscn") #actualizar
				else:
					get_tree().change_scene_to_file("res://Escenas/Menu/MainMenu/Menu_Principal.tscn") #actualizar
	if transicionando_in:
		$Transicion.modulate.a -= delta / transicion
		if $Transicion.modulate.a <= 0.0:
			$Transicion.modulate.a = 0.0
			transicionando_in = false

func transition_to_menu(): # como no hay ningun otro caso de transicion, no tengo que distinguir
	transicionando_in = false
	transicionando_out = true
