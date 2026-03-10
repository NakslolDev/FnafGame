extends Panel

signal button_hide

func _input(event):
	if visible and event.is_action_released("Esc"):
		_on_close_pressed()


@export var general: VBoxContainer
@export var gamestate: VBoxContainer


func _on_debug_menu_pressed() -> void:
	visible = true
	general.sync()
	gamestate.sync()

func _on_exit_debug_pressed() -> void:
	visible = false
	button_hide.emit()
	Global.reset_debug()

func _on_close_pressed() -> void:
	visible = false
	if Global.debug["game_state"]["override"]:
		Global.sync_current_to_debug()
