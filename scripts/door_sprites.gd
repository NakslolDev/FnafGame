extends Node2D

var open
var closed

func _ready():
	set_sprites()
	act_sprites()

func set_sprites():
	
	$Long/Door_Left.visible = false
	$Long/Door_Down.visible = false
	$Long/Door_Right.visible = false
	$Long/Door_Up.visible = false
	
	if $"..".pos == "Left_to_down":
		open = $Long/Door_Down
		closed = $Long/Door_Left
	elif $"..".pos == "Down_to_left":
		open = $Long/Door_Left
		closed = $Long/Door_Down
	elif $"..".pos == "Left_to_up":
		open = $Long/Door_Up
		closed = $Long/Door_Left
	elif $"..".pos == "Up_to_left":
		open = $Long/Door_Left
		closed = $Long/Door_Up
	elif $"..".pos == "Right_to_down":
		open = $Long/Door_Down
		closed = $Long/Door_Right
	elif $"..".pos == "Down_to_right":
		open = $Long/Door_Right
		closed = $Long/Door_Down
	elif $"..".pos == "Right_to_up":
		open = $Long/Door_Up
		closed = $Long/Door_Right
	elif $"..".pos == "Up_to_right":
		open = $Long/Door_Right
		closed = $Long/Door_Up

func act_sprites():
	if $"..".state_open:
		open.visible = true
		closed.visible = false
	else:
		open.visible = false
		closed.visible = true
