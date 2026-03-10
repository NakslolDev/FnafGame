extends Node2D

var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}

var animation_memory := false

@export var foxy: Sprite2D

@export var soft_focus: Area2D
@export var hard_focus: Area2D

func _ready() -> void:
	foxy.visible = false
	Foxy.movement.connect(movement)
	Foxy.front_duct_focus = self

func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc5" and Foxy.position == 0:
		foxy.visible = true
	else:
		foxy.visible = false

@export var ductos_fondo_oscuro: Sprite2D

func _on_linterna_linterna_activada_switch(value: bool, animation: bool) -> void:
	print("duct linterna act: ", value, ", animation, ", animation)
	animation_memory = animation
	shader_enabled = value
	if shader_enabled:
		ductos_fondo_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		ductos_fondo_oscuro.material.set_shader_parameter("shader_enabled", 0.0)


func get_focus_state() -> focus_state: # funcion llamada por los animatronicos

	if not shader_enabled and not animation_memory: return focus_state.NONE

	for overlaping_areas in hard_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.HARD

	for overlaping_areas in soft_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.SOFT

	return focus_state.NONE
