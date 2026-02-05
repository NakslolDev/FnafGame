extends Node2D

@export var root: CharacterBody2D
@export var animation: AnimatedSprite2D

var shift := false

func _ready():
	root.visible = true
	act_animation(false, "F", false)

func _process(_delta):
	if Input.is_action_pressed("Shift"):
		if shift == false:
			shift = true
			for anim_name in animation.sprite_frames.get_animation_names():
				animation.sprite_frames.set_animation_speed(anim_name, 8)
	
	else:
		if shift == true:
			shift = false
			for anim_name in animation.sprite_frames.get_animation_names():
				animation.sprite_frames.set_animation_speed(anim_name, 5)

func act_animation(waking: bool, dir: String, colided: bool):
	if dir == "":
		return
	if root.freeze:
		if str(animation.animation).ends_with("_Waking"):
				animation.play(dir)
		return
	if waking and not colided:
		dir += "_Waking"
	animation.play(dir)
