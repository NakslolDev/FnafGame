extends Node2D

var shift := false

func _ready():
	$Unnamed_Guard.visible = false
	$White.visible = false
	
	if $"..".character == "Unnamed_Guard":
		$Unnamed_Guard.visible = true
	else:
		$White.visible = true
	
	act_animation(false, "F", false)

func _process(_delta):
	if Input.is_action_pressed("Shift"):
		if shift == false:
			shift = true
			for anim_name in $Unnamed_Guard.sprite_frames.get_animation_names():
				$Unnamed_Guard.sprite_frames.set_animation_speed(anim_name, 8)
	
	else:
		if shift == true:
			shift = false
			for anim_name in $Unnamed_Guard.sprite_frames.get_animation_names():
				$Unnamed_Guard.sprite_frames.set_animation_speed(anim_name, 5)

func act_animation(waking: bool, dir: String, colided: bool):
	if dir == "":
		return
	if $"..".freeze:
		if str($Unnamed_Guard.animation).ends_with("_Waking"):
				$Unnamed_Guard.play(dir)
		return
	if waking and not colided:
		dir += "_Waking"
	$Unnamed_Guard.play(dir)
