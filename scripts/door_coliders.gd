extends Node2D

var col_open
var col_closed

func _ready():
	set_green_things()
	act_fisicas()


func set_green_things():
	var pos_door
	pos_door = $"..".pos
	
	$Colision_Right.collision_enabled = false
	$Colision_Left.collision_enabled = false
	$Colision_Down.collision_enabled = false
	$Colision_Up.collision_enabled = false
	
	if pos_door == "Left_to_down":
		col_closed = $Colision_Left
		col_open = $Colision_Down
	elif pos_door == "Left_to_up":
		col_closed = $Colision_Left
		col_open = $Colision_Up
	elif pos_door == "Right_to_down":
		col_closed = $Colision_Right
		col_open = $Colision_Down
	elif pos_door == "Right_to_up":
		col_closed = $Colision_Right
		col_open = $Colision_Up
	elif pos_door == "Down_to_left":
		col_closed = $Colision_Down
		col_open = $Colision_Left
	elif pos_door == "Down_to_right":
		col_closed = $Colision_Down
		col_open = $Colision_Right
	elif pos_door == "Up_to_left":
		col_closed = $Colision_Up
		col_open = $Colision_Left
	elif pos_door == "Up_to_right":
		col_closed = $Colision_Up
		col_open = $Colision_Right

func act_fisicas():
	if $"..".state_open:
		col_open.collision_enabled = true
		col_closed.collision_enabled = false
	else:
		col_open.collision_enabled = false
		col_closed.collision_enabled = true
