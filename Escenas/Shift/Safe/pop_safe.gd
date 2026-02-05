extends Node2D

var on := false
var wait_to_exit := false

var manual_exit_read := false
var auto_exit_read := false

func pop_up():
	on = true
	wait_to_exit = true
	$Safe/Wheel.combination = []

func exit(manual: bool, read: bool):
	on = false
	$"../.."._on_done_safing(manual, read, $Safe/Wheel.combination)


func _input(event: InputEvent) -> void:
	if not on:
		return
	if event.is_action_released("interact"):
		wait_to_exit = false
	if event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space") or (event.is_action_pressed("interact") and not wait_to_exit):
		exit(true, manual_exit_read)
		manual_exit_read = true


func _on_autoexit_timer_timeout() -> void:
	exit(false, auto_exit_read)
	auto_exit_read = true
