extends Node

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

@export var mediocre: Node2D
@export var party: Node2D
@export var bad: Node2D
@export var true_ending: Node2D

@export var time: Timer
@export var min_time: Timer

const TIME := 10.0
const MINIMUN_TIME := 4.0

var can_trans := false

func _ready():
	mediocre.visible = false
	party.visible = false
	bad.visible = false
	true_ending.visible = false
	time.start(TIME)
	min_time.start(MINIMUN_TIME)


func show_mediocre():
	mediocre.visible = true

func show_party():
	party.visible = true

func show_bad():
	bad.visible = true

func show_true():
	true_ending.visible = true


func exit():
	scene_handler.trans_to_scene(scene_handler.scene.MAIN_MENU)


func _on_time_timeout() -> void:
	can_trans = false
	exit()

func _on_min_time_timeout() -> void:
	can_trans = true

func _input(event) -> void:
	if can_trans:
		if event.is_action_pressed("Click") or event.is_action_pressed("interact") or event.is_action_pressed("Esc"):
			exit()
			can_trans = false
