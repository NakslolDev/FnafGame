extends VBoxContainer


func _on_delete_config_pressed() -> void:
	Global.delete_config_file()

func _on_delete_partida_pressed() -> void:
	Global.eliminar_partida()


func _on_delete_progress_pressed() -> void:
	Global.eliminar_progreso()
