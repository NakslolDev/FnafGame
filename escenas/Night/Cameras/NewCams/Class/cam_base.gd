extends Node2D
class_name CamBase

@export var cam_number: int
@export var sprites: Array[CamSprite]

func _ready():
	actualizar_cams()

func actualizar_cams():
	for sprite in sprites:
		sprite.actualice()


func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int) -> void:
	if freddy or local_from == cam_number or local_to == cam_number or local_extra == cam_number:
		actualizar_cams()
