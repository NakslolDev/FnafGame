extends Node2D

@export var root: CharacterBody2D
@export var sprite_2d: Sprite2D

var shift := false

func _ready():
	root.visible = true
	act_animation(false, "F", false)

func _process(_delta):
	if Input.is_action_pressed("Shift"):
		if shift == false:
			shift = true
			sprite_2d.timer.wait_time = 0.125
	
	else:
		if shift == true:
			shift = false
			sprite_2d.timer.wait_time = 0.2

func act_animation(waking: bool, dir: String, colided: bool):
	if dir == "":
		return
	if root.freeze:
		if str(sprite_2d.current).ends_with("_Walking"):
				sprite_2d.play(dir)
		return
	if waking and not colided:
		dir += "_Walking"
	sprite_2d.play(dir)
