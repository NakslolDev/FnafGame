extends Node2D

@export var canvas_modulate: CanvasModulate
@export var general: DirectionalLight2D
@export var general_left: DirectionalLight2D
@export var general_right: DirectionalLight2D
@export var ventanas: Array[PointLight2D]
@export var escenario: Array[PointLight2D]
@export var night_escenario: Array[PointLight2D]

func _ready() -> void:
	visible = true
	canvas_modulate.visible = true

func entering():
	general.energy = 0.1
	general_left.enabled = false
	general_right.enabled = false
	for light in ventanas:
		light.energy = 0.1
	for light in escenario:
		light.visible = false

func exiting():
	general.energy = 0.3
	for light in ventanas:
		light.energy = 0.35
	for light in night_escenario:
		light.visible = false
