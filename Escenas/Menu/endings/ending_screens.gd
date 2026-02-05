extends Node2D

@export_enum("mediocre", "party", "bad", "true", "good")
var ending: String

var transicionando_out := false
var transicionando_in := false

func _ready():
	
	transicionando_in = true
	
	if ending != null:
		Global.finales[ending] = true
	Global.custom_night = true
	Global.guardar_progreso()

func _process(delta):
	if transicionando_out:
		$Transicion.modulate.a += delta / 3
		if $Transicion.modulate.a >= 1.0:
			$Transicion.modulate.a = 1.0
			transicionando_out = false
			Global.escena_previa = "Victory_screen"
			get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn") #actualizar
	if transicionando_in:
		$Transicion.modulate.a -= delta / 5
		if $Transicion.modulate.a <= 0.0:
			$Transicion.modulate.a = 0.0
			transicionando_in = false

func _input(event: InputEvent) -> void:
	if $Timer.is_stopped() and (event.is_action_pressed("Click") or event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space") or event.is_action_pressed("interact")):
		transition_to_menu()

func transition_to_menu(): # como no hay ningun otro caso de transicion, no tengo que distinguir
	transicionando_in = false
	transicionando_out = true
