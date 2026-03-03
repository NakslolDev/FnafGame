extends Node2D

@export var izquierda := true
var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}
var focus: focus_state = focus_state.NONE

@export var bonnie: Sprite2D
@export var chica: Sprite2D
@export var foxy: Sprite2D

@export var oficina_fondo_oscuro: Sprite2D

@export var soft_focus: Area2D
@export var hard_focus: Area2D

func _ready():
	bonnie.visible = false
	chica.visible = false
	foxy.visible = false
	Bonnie.movement.connect(movement)
	Chica.movement.connect(movement)
	Foxy.movement.connect(movement)
	
	if izquierda:
		Bonnie.door_focus = self
		Foxy.left_door_focus = self
	else:
		Chica.door_focus = self
		Foxy.right_door_focus = self


func movement(_a = null, _b = null, _c = null, _d = null):
	if izquierda:
		if Bonnie.position == "PI":
			bonnie.visible = true
		elif Foxy.room == "lhall" and Foxy.position == 0:
			foxy.visible = true
		else:
			bonnie.visible = false
			foxy.visible = false
	else:
		if Chica.position == "PD":
			chica.visible = true
		elif Foxy.room == "rhall" and Foxy.position == 0:
			foxy.visible = true
		else:
			chica.visible = false
			foxy.visible = false

func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	if shader_enabled:
		oficina_fondo_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		oficina_fondo_oscuro.material.set_shader_parameter("shader_enabled", 0.0)

func get_focus_state() -> focus_state: # funcion llamada por los animatronicos

	if not shader_enabled: return focus_state.NONE

	for overlaping_areas in hard_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.HARD

	for overlaping_areas in soft_focus.get_overlapping_areas():
		if overlaping_areas.name.begins_with("MouseHitbox"):
			return focus_state.SOFT

	return focus_state.NONE
