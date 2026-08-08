extends CanvasLayer

@export var camaras_control: Node2D
@export var color_rect: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	camaras_control.cams_toggled.connect(act)

func act():
	visible = !camaras_control.camaras.activado
