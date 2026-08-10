extends Node2D

var flashlight_on := false

enum focus_state {NONE, SOFT, HARD}

var animation_memory := false

@export var foxy: Node2D

@export var soft_focus: Area2D
@export var hard_focus: Area2D

func _ready():
	foxy.visible = false
	Foxy.movement.connect(movement)
	Foxy.back_duct_focus = self


func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc8" and Foxy.position == 0:
		foxy.visible = true
	else:
		foxy.visible = false

func _on_oficina_detras_linterna_activada_rebote(value: bool, animation: bool) -> void:
	animation_memory = animation
	flashlight_on = value

func get_focus_state() -> focus_state: # funcion llamada por los animatronicos

	if not flashlight_on and not animation_memory: return focus_state.NONE

	for overlaping_areas in hard_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.HARD

	for overlaping_areas in soft_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.SOFT

	return focus_state.NONE
