extends CanvasLayer

const GROUP_NAME := "Brillantes"

var bright_sprites: Array[Node]

@export var visibility_control: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bright_sprites = get_tree().get_nodes_in_group(GROUP_NAME)
	for node in bright_sprites:
		node.leave_spot()
		node.reparent(visibility_control)
