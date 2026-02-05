extends HBoxContainer

var selected := 0
var hard_selected := 0

func _ready():
	act_selected()

func act_selected():
	
	$Back/Seleccion.visible = false
	$Ready/Seleccion.visible = false
	
	if selected == 1:
		$Back/Menu_Click.play()
		$Back/Seleccion.visible = true
	if selected == 2:
		$Ready/Menu_Click.play()
		$Ready/Seleccion.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("Space"):
		if selected == 1:
			back()
		elif selected == 2:
			play()
	
	if event.is_action_pressed("Click"):
		if hard_selected == 1:
			back()
		elif hard_selected == 2:
			play()

	if event.is_action_pressed("Esc"):
		back()

func play():
	if Global.custom_night_ai == [1, 9, 8, 7]:
		get_tree().quit()
	$"../..".transition_to_play()

func back():
	Global.escena_previa = "Custom_Night"
	Global.leer_partida()
	get_tree().change_scene_to_file("res://Escenas/Menu/MainMenu/Menu_Principal.tscn") #actualizar


func _on_back_mouse_entered() -> void:
	hard_selected = 1
	if selected != 1:
		selected = 1
		act_selected()

func _on_back_mouse_exited() -> void:
	if selected == 1:
		hard_selected = 0

func _on_ready_mouse_entered() -> void:
	hard_selected = 2
	if selected != 2:
		selected = 2
		act_selected()

func _on_ready_mouse_exited() -> void:
	if selected == 2:
		hard_selected = 0
