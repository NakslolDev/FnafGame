extends CanvasLayer

@export var visible_on_ready := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = visible_on_ready
