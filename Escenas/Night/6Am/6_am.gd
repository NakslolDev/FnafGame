extends Node2D

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

@export var numbers: Node2D
@export var timer: Timer
@export var hall_of_fame: AudioStreamPlayer


const VELOCITY := 80.0
var moving_6 := false
var velocity := 0.0

var exiting := false

func _ready():
	timer.start()
	hall_of_fame.play()

func _process(delta):
	if moving_6: # movimiento -> 0 -> -475
		numbers.position.y -= delta * velocity
		if numbers.position.y <= -475.0/2.0 and velocity <= 0:
			moving_6 = false
		if numbers.position.y >= -475.0/2.0: # es un poco más de la mitad para que no frene del todo
			velocity += delta * VELOCITY
		else:
			velocity -= delta * VELOCITY


func exit():
	if Global.noche == 0:
		scene_handler.trans_to_scene(scene_handler.scene.CUSTOM_NIGHT)
	else:
		scene_handler.trans_to_scene(scene_handler.scene.SHIFT)


func _on_timer_1_timeout() -> void:
	moving_6 = true

func _on_hall_of_fame_finished() -> void:
	exiting = true
	exit()

func _input(event: InputEvent) -> void:
	if exiting:
		return
	if event.is_action_pressed("Click") or event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space"):
		exit()
		exiting = true
