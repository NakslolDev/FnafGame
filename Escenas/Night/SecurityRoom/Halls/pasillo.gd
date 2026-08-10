extends Node2D

@export var izquierda := true

enum focus_state {NONE, SOFT, HARD}
var focus: focus_state = focus_state.NONE
var flashlight_on: bool = false

var animation_memory := false

@export var bonnie: Node2D
@export var foxy: Node2D
@export var chica: Node2D

@export var soft_focus: Area2D
@export var hard_focus: Area2D

func _ready():
	bonnie.visible = true
	chica.visible = true
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
		bonnie.visible = Bonnie.position == "PI"
		foxy.visible = (Foxy.room == "lhall" and Foxy.position == 0)
	else:
		chica.visible = Chica.position == "PD"
		foxy.visible = Foxy.room == "rhall" and Foxy.position == 0


func _on_linterna_linterna_activada_switch(value: bool, animation: bool) -> void:
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
