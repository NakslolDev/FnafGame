extends Node2D

@export var locked := false

@export_enum("Left_to_down", "Left_to_up", "Right_to_down", "Right_to_up", "Down_to_left", "Down_to_right", "Up_to_left", "Up_to_right")
var pos := "Left_to_down"

@export var state_open := false

func change_door(state := false):
	if locked:
		return
	state_open = state
	$Sprites.act_sprites()
	$Coliders.act_fisicas()
