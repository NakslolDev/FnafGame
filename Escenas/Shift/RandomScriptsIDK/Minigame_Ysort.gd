extends Node2D

@export var check_for_visibility := false

@export var player: CharacterBody2D
@export var Walls: Array[CanvasGroup]
@export var nodes: Array[Node]

var last_player_ypos: float

const FADE_TIME := 0.5

func _ready():

	for node in nodes:
		var children: Array[Node] = node.get_children()
		for child in children:
			child.reparent(self)
		node.queue_free()

	for wall in Walls: # Esto lo hago para mantener las paredes invisibles, ya que tapan mucho
		wall.visible = true
		if player.position.y >= wall.position.y:
			wall.self_modulate.a = 1.0
		else:
			wall.self_modulate.a = 0.0

		if check_for_visibility:
			check_layer_3(wall)


func _process(delta: float) -> void: # Podria optimizarse, pero de momento lo vamos a dejar asi, pues tampoco hay problema
	for wall in Walls:
		if player.position.y >= wall.position.y:
			if wall.self_modulate.a <= 1.0:
				wall.self_modulate.a += delta / FADE_TIME
		else:
			if wall.self_modulate.a >= 0.0:
				wall.self_modulate.a -= delta / FADE_TIME

func check_layer_3(node):
	if node.get_light_mask() != 4:
		push_warning("Light mask on ", node.name, " (", node, ") is not 3")
	for child in node.get_children():
		check_layer_3(child)
