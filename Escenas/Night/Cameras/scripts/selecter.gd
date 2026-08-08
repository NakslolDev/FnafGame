extends Node2D

@export var camaras: Node2D
@export var cam_selecter: Sprite2D
@export var cam_selecter_hl: Sprite2D
@export var duct_selecter: Sprite2D
@export var duct_selecter_hl: Sprite2D

var mouse_in := false

func _ready():
	duct_selecter_hl.visible = false
	cam_selecter_hl.visible = false
	act_button()

func act_button():
	if camaras.ductos:
		cam_selecter_hl.visible = false
		cam_selecter.visible = false
		duct_selecter.visible = true
		if mouse_in:
			duct_selecter_hl.visible = true
		else:
			duct_selecter_hl.visible = false
	else:
		duct_selecter_hl.visible = false
		cam_selecter.visible = true
		duct_selecter.visible = false
		if mouse_in:
			cam_selecter_hl.visible = true
		else:
			cam_selecter_hl.visible = false

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		camaras.ductos = !camaras.ductos
		act_button()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true
	act_button()

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
	act_button()
