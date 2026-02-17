extends Panel

signal button_hide

func _input(event):
	if visible and event.is_action_released("Esc"):
		_on_close_pressed()


func _on_debug_menu_pressed() -> void:
	visible = true
	$ScrollContainer/VBoxContainer.sync()

func _on_exit_debug_pressed() -> void:
	visible = false
	emit_signal("button_hide")
	Global.reset_debug()
	

func _on_close_pressed() -> void:
	visible = false
	if Global.debug["game_state"]["override"]:
		Global.guardar_partida(true)
