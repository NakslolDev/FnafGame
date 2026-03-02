extends Node2D

var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}
var focus: focus_state = focus_state.NONE

@export var foxy: Sprite2D

func _ready():
	foxy.visible = false
	Foxy.movement.connect(movement)

func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc5" and Foxy.position == 0:
		foxy.visible = true
	else:
		foxy.visible = false

@export var ductos_fondo_oscuro: Sprite2D

func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	act_linerna_focus()
	if shader_enabled:
		ductos_fondo_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		ductos_fondo_oscuro.material.set_shader_parameter("shader_enabled", 0.0)


func act_linerna_focus():
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Acted focus front ducts: ", focus_state.keys()[focus])
	if shader_enabled and focus != focus_state.NONE:
		Foxy.soft_focus_DF = true
		if focus == focus_state.HARD:
			Foxy.hard_focus_DF = true
		else:
			Foxy.hard_focus_DF = false
	else:
		Foxy.hard_focus_DF = false
		Foxy.soft_focus_DF = false

func _on_soft_focus_mouse_entered() -> void:
	focus = focus_state.SOFT
	act_linerna_focus()

func _on_soft_focus_mouse_exited() -> void:
	focus = focus_state.NONE
	act_linerna_focus()

func _on_hard_focus_mouse_entered() -> void:
	focus = focus_state.HARD
	act_linerna_focus()

func _on_hard_focus_mouse_exited() -> void:
	focus = focus_state.SOFT
	act_linerna_focus()
