extends AnimatedSprite2D
class_name BrightAnimatedSprite

const GROUP_NAME := "Brillantes"
const CANVAS_LAYER_OFFSET := Vector2(960.0, 540.0)

var in_canvas: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(GROUP_NAME)

var spot: Node2D
func leave_spot():
	spot = Node2D.new()
	add_sibling(spot)
	spot.position = position
	in_canvas = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if in_canvas:
		global_position = spot.global_position + CANVAS_LAYER_OFFSET
		visible = spot.is_visible_in_tree()
