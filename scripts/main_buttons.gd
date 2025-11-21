extends VBoxContainer

var active := true
var selected := 0
var hard_selected := 0

func _ready():
	act_selected()

func act_selected():
	
	$Play/Seleccion.modulate.a = 0.0
	$Options/Seleccion.modulate.a = 0.0
	$Exit/Seleccion.modulate.a = 0.0
	
	if selected == 1:
		$Play/Menu_Click.play()
		$Play/Seleccion.modulate.a = 1.0
	if selected == 2:
		$Options/Menu_Click.play()
		$Options/Seleccion.modulate.a = 1.0
	if selected == 3:
		$Exit/Menu_Click.play()
		$Exit/Seleccion.modulate.a = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("Space"):
		if selected == 1:
			play()
		elif selected == 2:
			options()
		elif selected == 3:
			exit()
	
	if event.is_action_pressed("Click"):
		if hard_selected == 1:
			play()
		elif hard_selected == 2:
			options()
		elif hard_selected == 3:
			exit()
	
	if event.is_action_pressed("Esc"):
		exit()

func play():
	$".".set_process_input(false)
	$".".visible = false
	$"../Play_Buttons".set_process_input(true)
	$"../Play_Buttons".visible = true

func options():
	Global.escena_previa = "Menu_Principal"
	get_tree().change_scene_to_file("res://escenas/Opciones.tscn")

func exit():
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	selected = 1
	hard_selected = 1
	act_selected()

func _on_play_mouse_exited() -> void:
	if selected == 1:
		hard_selected = 0

func _on_options_mouse_entered() -> void:
	selected = 2
	hard_selected = 2
	act_selected()

func _on_options_mouse_exited() -> void:
	if selected == 2:
		hard_selected = 0

func _on_exit_mouse_entered() -> void:
	selected = 3
	hard_selected = 3
	act_selected()

func _on_exit_mouse_exited() -> void:
	if selected == 3:
		hard_selected = 0
