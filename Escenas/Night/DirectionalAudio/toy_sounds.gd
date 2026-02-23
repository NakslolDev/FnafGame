extends Node

@export var left: spacial_audio
@export var right: spacial_audio

@export var toy_sounds: Array[AudioStream]
@export var pop_sounds: Array[AudioStream]
@export var easter_egg_sounds: Array[AudioStream]

const LEFT_NAME := "left_door_toy"
const RIGHT_NAME := "right_door_toy"

func _ready() -> void:
	Items.left_toy_squeek.connect(_left)
	Items.right_toy_squeek.connect(_right)

# make all sounds

func _left():
	if Items.objects[LEFT_NAME]:
		left.stream = toy_sounds.pick_random()
		if randi_range(0,999) == 0:
			left.stream = easter_egg_sounds.pick_random() 
	else:
		left.stream = pop_sounds.pick_random()
	
	left._volume = 0.0
	if Global.energia["Luces"]:
		left._volume -= 5.0
	if Freddy.door_I_closed:
		left._volume -= 5.0
	
	left.change_volume()
	
	left.play()

func _right():
	if Items.objects[RIGHT_NAME]:
		right.stream = toy_sounds.pick_random()
		if randi_range(0,999) == 0:
			right.stream = easter_egg_sounds.pick_random() 
	else:
		right.stream = pop_sounds.pick_random()
	
	right._volume = 0.0
	if Global.energia["Luces"]:
		right._volume -= 5.0
	if Freddy.door_D_closed:
		right._volume -= 5.0
	
	right.change_volume()
	
	right.play()
