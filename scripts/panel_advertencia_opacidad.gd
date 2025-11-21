extends Panel

func hide_pannel():
	$".".visible = false
	$".".set_process(false)
	$".".set_process_input(false)
	$".".set_process_unhandled_input(false)
	$".".set_process_unhandled_key_input(false)

func show_pannel():
	$".".visible = true
	$".".set_process(true)
	$".".set_process_input(true)
	$".".set_process_unhandled_input(true)
	$".".set_process_unhandled_key_input(true)

func _ready():
	hide_pannel()

func _on_h_slider_warning_op() -> void:
	show_pannel()


func _on_button_ik_pressed() -> void:
	hide_pannel()

func _on_button_cancel_pressed() -> void:
	hide_pannel()
