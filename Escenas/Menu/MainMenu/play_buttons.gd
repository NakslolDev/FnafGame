extends VBoxContainer

var active := false
var selected := 0
var hard_selected := 0

@export_category("nodes")
@export var menu_principal: Node2D
@export var main_buttons: VBoxContainer

@export var node_continue: HBoxContainer
@export var node_new_game: HBoxContainer
@export var node_custom_night: HBoxContainer
@export var node_back: HBoxContainer

@export var continue_seleccion: Sprite2D
@export var new_game_seleccion: Sprite2D
@export var cn_seleccion: Sprite2D
@export var back_seleccion: Sprite2D

@export var night_label: Label
@export var menu_click: AudioStreamPlayer

func _ready():
	set_process_input(false)
	visible = false
	act_selected()

func _process(delta):
	var night_alpha = night_label
	if selected == 1 and night_alpha.modulate.a < 0.6:
		night_alpha.modulate.a += delta / 3.0
	if selected != 1 and night_alpha.modulate.a > 0.0:
		night_alpha.modulate.a -= delta / 3.0

func act_selected(just_selected := false):
	
	if not just_selected:
		node_continue.visible = menu_principal.game_exist
		node_custom_night.visible = Global.custom_night
	
		if Global.debug["game_state"]["override"]:
			node_continue.visible = true
			night_label.text = get_tree().current_scene.get_text("Night_") + " " + str(menu_principal.noche_menu) + " [debug game state]"
		else:
			night_label.text = get_tree().current_scene.get_text("Night_") + " " + str(menu_principal.noche_menu)
	
	continue_seleccion.visible = false
	new_game_seleccion.visible = false
	cn_seleccion.visible = false
	back_seleccion.visible = false
	
	if selected == 1:
		continue_seleccion.visible = true
	if selected == 2:
		new_game_seleccion.visible = true
	if selected == 3:
		cn_seleccion.visible = true
	if selected == 4:
		back_seleccion.visible = true

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
	menu_principal.transition_to_play()

func new_game():
	Global.create_new_game()
	menu_principal.transition_to_play()

func custom_night():
	Global.escena_previa = "Menu_Principal"
	get_tree().change_scene_to_file("res://Escenas/Menu/CN/custom_night_selecter.tscn") #actualizar

func back():
	set_process_input(false)
	visible = false
	main_buttons.set_process_input(true)
	main_buttons.visible = true


func _on_continue_mouse_entered() -> void:
	hard_selected = 1
	if selected != 1:
		selected = 1
		menu_click.play()
		act_selected(true)

func _on_continue_mouse_exited() -> void:
	if selected == 1:
		hard_selected = 0

func _on_new_game_mouse_entered() -> void:
	hard_selected = 2
	if selected != 2:
		selected = 2
		menu_click.play()
		act_selected(true)

func _on_new_game_mouse_exited() -> void:
	if selected == 2:
		hard_selected = 0

func _on_custom_night_mouse_entered() -> void:
	hard_selected = 3
	if selected != 3:
		selected = 3
		menu_click.play()
		act_selected(true)

func _on_custom_night_mouse_exited() -> void:
	if selected == 3:
		hard_selected = 0

func _on_back_mouse_entered() -> void:
	hard_selected = 4
	if selected != 4:
		selected = 4
		menu_click.play()
		act_selected(true)

func _on_back_mouse_exited() -> void:
	if selected == 4:
		hard_selected = 0
