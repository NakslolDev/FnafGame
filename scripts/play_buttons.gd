extends VBoxContainer

var active := false
var selected := 0
var hard_selected := 0

func _ready():
	$".".set_process_input(false)
	$".".visible = false

func _process(delta):
	var night_alpha = $Continue/Get_out_of_jail_card/Night_label
	if selected == 1 and night_alpha.modulate.a < 0.6:
		night_alpha.modulate.a += delta / 3.0
	if selected != 1 and night_alpha.modulate.a > 0.0:
		night_alpha.modulate.a -= delta / 3.0

func act_selected(just_selected := false):
	
	if not just_selected:
		$Continue.visible = $"..".game_exist
		$Custom_Night.visible = Global.custom_night
	
		if Global.debug["game_state"]["override"]:
			$Continue.visible = true
			$Continue/Get_out_of_jail_card/Night_label.text = get_tree().current_scene.get_text("Night_") + " " + str($"..".noche_menu) + " [debug game state]"
		else:
			$Continue/Get_out_of_jail_card/Night_label.text = get_tree().current_scene.get_text("Night_") + " " + str($"..".noche_menu)
	
	$Continue/Seleccion.visible = false
	$New_Game/Seleccion.visible = false
	$Custom_Night/Seleccion.visible = false
	$Back/Seleccion.visible = false
	
	if selected == 1:
		$Continue/Menu_Click.play()
		$Continue/Seleccion.visible = true
	if selected == 2:
		$New_Game/Menu_Click.play()
		$New_Game/Seleccion.visible = true
	if selected == 3:
		$Custom_Night/Menu_Click.play()
		$Custom_Night/Seleccion.visible = true
	if selected == 4:
		$Back/Menu_Click.play()
		$Back/Seleccion.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("Space"):
		if selected == 1:
			_continue()
		elif selected == 2:
			new_game()
		elif selected == 3:
			custom_night()
		elif selected == 4:
			back()
	
	if event.is_action_pressed("Click"):
		if hard_selected == 1:
			_continue()
		elif hard_selected == 2:
			new_game()
		elif hard_selected == 3:
			custom_night()
		elif selected == 4:
			back()
	
	if event.is_action_pressed("Esc"):
		back()

func _continue():
	$"..".transition_to_play()

func new_game():
	Global.create_new_game()
	$"..".transition_to_play()

func custom_night():
	Global.escena_previa = "Menu_Principal"
	get_tree().change_scene_to_file("res://escenas/custom_night_selecter.tscn")

func back():
	$".".set_process_input(false)
	$".".visible = false
	$"../Main_buttons".set_process_input(true)
	$"../Main_buttons".visible = true


func _on_continue_mouse_entered() -> void:
	selected = 1
	hard_selected = 1
	act_selected(true)

func _on_continue_mouse_exited() -> void:
	if selected == 1:
		hard_selected = 0

func _on_new_game_mouse_entered() -> void:
	selected = 2
	hard_selected = 2
	act_selected(true)

func _on_new_game_mouse_exited() -> void:
	if selected == 2:
		hard_selected = 0

func _on_custom_night_mouse_entered() -> void:
	selected = 3
	hard_selected = 3
	act_selected(true)

func _on_custom_night_mouse_exited() -> void:
	if selected == 3:
		hard_selected = 0

func _on_back_mouse_entered() -> void:
	selected = 4
	hard_selected = 4
	act_selected(true)

func _on_back_mouse_exited() -> void:
	if selected == 4:
		hard_selected = 0
