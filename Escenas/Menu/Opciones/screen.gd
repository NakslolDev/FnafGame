extends VBoxContainer

@export var vsync: Button
@export var fps_label: Label
@export var fps_h_slider: HSlider
@export var fullscreen: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.screen["vsync"]:
		vsync.text = "V-sync"
	else:
		vsync.text = "no V-sync"
	
	fps_h_slider.value = fps_options.find(Global.screen["fps"])
	if fps_h_slider.value == -1: fps_h_slider.value = 0
	
	if fps_h_slider.value == 0:
		fps_label.text = "FPS: inf"
	else:
		fps_label.text = "FPS: " + str(fps_options[fps_h_slider.value])
	
	if Global.screen["fullscreen"]:
		fullscreen.text = "fullscreen"
	else:
		fullscreen.text = "windowed"


func _on_button_cam_lights_pressed() -> void:
	Global.screen["vsync"] = !Global.screen["vsync"]
	if Global.screen["vsync"]:
		vsync.text = "V-sync"
	else:
		vsync.text = "no V-sync"
	Global.aply_screen_configuration()

func _on_fullscreen_pressed() -> void:
	Global.screen["fullscreen"] = !Global.screen["fullscreen"]
	Global.aply_screen_configuration()
	if Global.screen["fullscreen"]:
		fullscreen.text = "fullscreen"
	else:
		fullscreen.text = "windowed"


var fps_options := [0, 30, 60, 75, 90, 120, 144, 240]

func _on_h_slider_value_changed(value: int) -> void:
	
	var fps_value: int = fps_options[value]
	
	Global.screen["fps"] = fps_value
	Global.aply_screen_configuration()
	
	if value == 0:
		fps_label.text = "FPS: inf"
	else:
		fps_label.text = "FPS: " + str(fps_value)
