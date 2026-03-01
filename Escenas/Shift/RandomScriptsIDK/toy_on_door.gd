extends Sprite2D

@export var left: bool = true

func act():
	if left:
		visible = Items.objects["left_door_toy"]
	else:
		visible = Items.objects["right_door_toy"]
