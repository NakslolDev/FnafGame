extends Node2D

@export var background: Node
@export var day: Node
@export var time: Node

var entering_trans := true

const duration := 3.0

signal done
signal done_out

func _ready():
	if not Global.just_death_min == "none":
		visible = false
		return
	
	if Global.m_entering:
		entrance()
	else:
		exit()

func entrance():
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
	
	for i in range(3,10):
		if i == 7 and entering_trans:
			start_fade()
		time.text = "23:53:1" + str(i)
		await get_tree().create_timer(1.0).timeout

func exit():
	visible = true
	modulate.a = 1.0
	background.visible = true
	day.visible = false
	time.visible = false
	if entering_trans:
		start_fade()

func start_fade():
	
	var tween := create_tween()
	
	tween.tween_property(self, "modulate:a", 0.3, duration*0.7)
	tween.tween_callback(func():
		emit_signal("done")
	)
	tween.tween_property(self, "modulate:a", 0.0, duration*0.3)


func out():
	entering_trans = false
	day.visible = false
	time.visible = false
	background.visible = true
	visible = true
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration*0.5)
	tween.finished.connect(func():
		await get_tree().process_frame
		emit_signal("done_out")
	)

func _input(event: InputEvent) -> void:
	if not entering_trans:
		return
	if event.is_action_pressed("Click") or event.is_action_pressed("interact"):
		entering_trans = false
		start_fade()
