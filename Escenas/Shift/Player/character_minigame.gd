extends CharacterBody2D

@export var speed := 100.0
@export var run_mult := 1.5
@export var step := 1
var freeze := false


@export var skins: Node2D
@export var light_occluder_2d_escenario: LightOccluder2D

var skin_initial_lift: float

func _ready() -> void:
	skin_initial_lift = skins.position.y

func set_height(value: float):
	skins.position.y = skin_initial_lift - value
	light_occluder_2d_escenario.visible = value > 0.01
