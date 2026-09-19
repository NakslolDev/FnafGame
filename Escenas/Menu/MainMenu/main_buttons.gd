extends VBoxContainer

var active := true
var selected := 0
var hard_selected := 0

@export_category("nodes")

@export var menu_principal: Node2D

@export var play_buttons: VBoxContainer

@export var play_seleccion: Sprite2D
@export var options_seleccion: Sprite2D
@export var extras_seleccion: Sprite2D
@export var exit_seleccion: Sprite2D

@export var menu_click: AudioStreamPlayer

func _ready():
	act_selected()

func act_selected():
	
	play_seleccion.visible = false
	options_seleccion.visible = false
	extras_seleccion.visible = false
	exit_seleccion.visible = false
	
	if selected == 1:
		play_seleccion.visible = true
	if selected == 2:
		options_seleccion.visible = true
	if selected == 3:
		extras_seleccion.visible = true
	if selected == 4:
		exit_seleccion.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Enter") or event.is_action_pressed("Space"):
		if selected == 1:
			play()
		elif selected == 2:
			options()
		elif selected == 3:
			extras()
		elif selected == 4:
			exit()
	
	if event.is_action_pressed("Click"):
		if hard_selected == 1:
			play()
		elif hard_selected == 2:
			options()
		elif hard_selected == 3:
			extras()
		elif hard_selected == 4:
			exit()
	
	if event.is_action_pressed("Esc"):
		if alpha_message.visible:
			alpha_message.visible = false
		else:
			exit()

func play():
	set_process_input(false)
	visible = false
	play_buttons.set_process_input(true)
	play_buttons.visible = true

func options():
	menu_principal.options()

@export var alpha_message: Panel
func extras():
	alpha_message.visible = true

func exit():
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	hard_selected = 1
	if selected != 1:
		selected = 1
		menu_click.play()
		act_selected()

func _on_play_mouse_exited() -> void:
	if selected == 1:
		hard_selected = 0

func _on_options_mouse_entered() -> void:
	hard_selected = 2
	if selected != 2:
		selected = 2
		menu_click.play()
		act_selected()

func _on_options_mouse_exited() -> void:
	if selected == 2:
		hard_selected = 0

func _on_extras_mouse_entered() -> void:
	hard_selected = 3
	if selected != 3:
		selected = 3
		menu_click.play()
		act_selected()

func _on_extras_mouse_exited() -> void:
	if selected == 3:
		hard_selected = 0

func _on_exit_mouse_entered() -> void:
	hard_selected = 4
	if selected != 4:
		selected = 4
		menu_click.play()
		act_selected()

func _on_exit_mouse_exited() -> void:
	if selected == 4:
		hard_selected = 0
