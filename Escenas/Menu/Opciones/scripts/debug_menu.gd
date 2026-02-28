extends Button

@export var opciones: Control

var inputs := []

func _ready():
	visible = Global.debug["debug_mode"]
	if opciones.debug:
		visible = true
		Global.debug["prevent_save"] = true
		Global.debug["debug_mode"] = true

func _input(event: InputEvent) -> void:
	
	if Global.debug["debug_mode"]:
		return

	if event.is_action_pressed("W"):
		inputs.append(1)
	elif event.is_action_pressed("S"):
		inputs.append(2)
	elif event.is_action_pressed("A"):
		inputs.append(3)
	elif event.is_action_pressed("D"):
		inputs.append(4)
	
	if inputs == [1,1,2,2,3,4,3,4]:
		visible = true
		Global.debug["prevent_save"] = true
		Global.debug["debug_mode"] = true
	
	while len(inputs) > 8:
		inputs.pop_front()


func _on_debug_panel_button_hide() -> void:
	visible = false
	inputs = []
