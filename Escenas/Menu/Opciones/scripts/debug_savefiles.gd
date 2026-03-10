extends VBoxContainer

func _on_save_game_pressed() -> void:
	Global.guardar_partida()

func _on_force_save_game_debug_pressed() -> void:
	var safe_save: bool = Global.debug["prevent_save"]
	Global.debug["prevent_save"] = false
	Global.sync_current_to_debug()
	Global.guardar_partida()
	Global.debug["prevent_save"] = safe_save

func _on_save_progress_pressed() -> void:
	Global.guardar_progreso()

func _on_force_save_progress_debug_pressed() -> void:
	var safe_save: bool = Global.debug["prevent_save"]
	Global.debug["prevent_save"] = false
	# aqui deveria de ir el susodicho sync progress to debug
	Global.guardar_progreso()
	Global.debug["prevent_save"] = safe_save

func _on_delete_config_pressed() -> void:
	Global.delete_config_file()

func _on_delete_partida_pressed() -> void:
	Global.eliminar_partida()

func _on_delete_progress_pressed() -> void:
	Global.eliminar_progreso()
