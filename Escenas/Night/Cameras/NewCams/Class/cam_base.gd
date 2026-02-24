extends Node2D
class_name CamBase

@export var cam_number: int
var sprites: Array[CamSprite] = []

var alucinaciones: Array[Dictionary]

func _ready():
	_connect_cams()
	actualizar_cams()

func _connect_cams():
	for child in get_children():
		if child is CamSprite:
			sprites.append(child)

func actualizar_cams():
	for sprite in sprites:
		sprite.actualice()

func _on_cam_cam_act(freddy: bool, local_from: int, local_to: int, local_extra: int) -> void:
	if freddy or local_from == cam_number or local_to == cam_number or local_extra == cam_number:
		actualizar_cams()
