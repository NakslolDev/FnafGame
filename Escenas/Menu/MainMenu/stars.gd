extends Node2D

func _ready():
	
	$WhiteStar2_true_ending.visible = false
	$WhiteStar3_420.visible = false
	$WhiteStar_ending.visible = false
	for key in Global.finales:
		if key.is_valid_int() :
			if Global.finales[key]:
				$WhiteStar3_420.visible = true
		else:
			if Global.finales[key]:
				$WhiteStar_ending.visible = true
				if key == "good":
					$WhiteStar2_true_ending.visible = true
	
	
