extends Node2D

@export var canvas_modulate: CanvasModulate
@export var general: DirectionalLight2D
@export var ventanas: Array[PointLight2D]

func _ready() -> void:
	visible = true
	canvas_modulate.visible = true

func entering():
	general.energy = 0.1
	for light in ventanas:
		light.energy = 0.1

func exiting():
	general.energy = 0.4
	for light in ventanas:
		light.energy = 0.5
