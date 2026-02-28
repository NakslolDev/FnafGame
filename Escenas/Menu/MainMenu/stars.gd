extends Node2D

@export var white_star_ending: Sprite2D
@export var white_star_2_true_ending: Sprite2D
@export var white_star_3_420: Sprite2D

func _ready():
	
	white_star_2_true_ending.visible = false
	white_star_3_420.visible = false
	white_star_ending.visible = false
	for key in Global.finales:
		if key.is_valid_int():
			if Global.finales[key]:
				white_star_3_420.visible = true
		else:
			if Global.finales[key]:
				white_star_ending.visible = true
				if key == "good":
					white_star_2_true_ending.visible = true
	
	
