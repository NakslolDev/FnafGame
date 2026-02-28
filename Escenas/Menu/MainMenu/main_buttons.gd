extends VBoxContainer

var active := true
var selected := 0
var hard_selected := 0

@export_category("nodes")

@export var menu_principal: Node2D

@export var play_buttons: VBoxContainer

@export var play_seleccion: Sprite2D
@export var options_seleccion: Sprite2D
@export var exit_seleccion: Sprite2D

@export var menu_click: AudioStreamPlayer

func _ready():
	act_selected()

func act_selected():
	
	play_seleccion.modulate.a = 0.0
	options_seleccion.modulate.a = 0.0
	exit_seleccion.modulate.a = 0.0
	
	if selected == 1:
		play_seleccion.modulate.a = 1.0
	if selected == 2:
		options_seleccion.modulate.a = 1.0
	if selected == 3:
		exit_seleccion.modulate.a = 1.0

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
	set_process_input(false)
	visible = false
	play_buttons.set_process_input(true)
	play_buttons.visible = true

func options():
	menu_principal.options()

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

func _on_exit_mouse_entered() -> void:
	hard_selected = 3
	if selected != 3:
		selected = 3
		menu_click.play()
		act_selected()

func _on_exit_mouse_exited() -> void:
	if selected == 3:
		hard_selected = 0
