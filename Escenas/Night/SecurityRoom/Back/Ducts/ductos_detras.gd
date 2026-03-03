extends Node2D

var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}

@export var ducto_detras_oscuro: Sprite2D
@export var foxy: Sprite2D

@export var soft_focus: Area2D
@export var hard_focus: Area2D

func _ready():
	foxy.visible = false
	Foxy.movement.connect(movement)
	Foxy.back_duct_focus = self

func _exit_tree() -> void: # elimina la referencia
	if Foxy.back_duct_focus == self:
		Foxy.back_duct_focus = null

func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc8" and Foxy.position == 0:
		foxy.visible = true
	else:
		foxy.visible = false

func _on_oficina_detras_linterna_activada_rebote() -> void:
	shader_enabled = !shader_enabled
	if shader_enabled:
		ducto_detras_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		ducto_detras_oscuro.material.set_shader_parameter("shader_enabled", 0.0)

func get_focus_state() -> focus_state: # funcion llamada por los animatronicos

	if not shader_enabled: return focus_state.NONE

	for overlaping_areas in hard_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.HARD

	for overlaping_areas in soft_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.SOFT

	return focus_state.NONE
