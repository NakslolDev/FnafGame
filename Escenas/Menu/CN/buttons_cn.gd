extends HBoxContainer

@export var back_selection: Sprite2D
@export var ready_selection: Sprite2D
@export var menu_click: AudioStreamPlayer
@export var custom_night_selecter: Node2D


var selected := 0
var hard_selected := 0

func _ready():
	act_selected()

func act_selected():
	
	back_selection.visible = false
	ready_selection.visible = false
	
	if selected == 1:
		menu_click.play()
		back_selection.visible = true
	if selected == 2:
		menu_click.play()
		ready_selection.visible = true

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
	custom_night_selecter.start_night()

func back():
	custom_night_selecter.go_back()


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
