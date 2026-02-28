extends Node2D

@export var root: Node
@export var background: Node
@export var day: Node
@export var time: Node

var entering_trans := false

var fading_out := false

const DURATION := 3.0

signal done

func _ready():
	if not Global.just_death_min == "none":
		visible = false
		return
	
	if Global.m_entering:
		entrance()

func entrance():
	entering_trans = true
	root.transitioning = true
	visible = true
	modulate.a = 1.0
	background.visible = true
	day.visible = false
	time.visible = false
	
	await get_tree().create_timer(2.0).timeout
	
	if not entering_trans:
		return
	day.visible = true
	
	await get_tree().create_timer(2.0).timeout
	
	if not entering_trans:
		return
	time.visible = true
	
	var minutes: int = randi_range(2, 9)
	var seconds: int = randi_range(0, 52)
	
	for i in range(7):
		if i == 4 and entering_trans:
			start_fade()
		time.text = "23:5" + str(minutes) + ":" + str(seconds+i).pad_zeros(2)
		await get_tree().create_timer(1.0).timeout


func start_fade():
	
	fading_out = true
	
	var tween := create_tween()
	
	tween.tween_property(self, "modulate:a", 0.3, DURATION*0.7)
	tween.tween_callback(func():
		done.emit()
	)
	tween.tween_property(self, "modulate:a", 0.0, DURATION*0.3)
	tween.tween_callback(func():
		fading_out = false
		entering_trans = false
	)


func _input(event: InputEvent) -> void:
	if not entering_trans or fading_out:
		return
	if event.is_action_pressed("Click") or event.is_action_pressed("interact"):
		entering_trans = false
		start_fade()
