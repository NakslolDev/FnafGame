extends CanvasLayer

@export var UI_Sader := false

func _ready():
	if UI_Sader:
		layer = 0
		$Linterna_Bateria_Icono.position.y = 845.0
		$Energia_Icono.position.y = 915.0
	else:
		layer = 2
		$Linterna_Bateria_Icono.position.y = 925.0
		$Energia_Icono.position.y = 995.0
