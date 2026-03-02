extends Node2D

var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}
var focus: focus_state = focus_state.NONE

@export var ducto_detras_oscuro: Sprite2D
@export var foxy: Sprite2D

func _ready():
	foxy.modulate.a = 0.0
	Foxy.movement.connect(movement)

func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc8" and Foxy.position == 0:
		foxy.modulate.a = 1.0
	else:
		foxy.modulate.a = 0.0

func _on_oficina_detras_linterna_activada_rebote() -> void:
	shader_enabled = !shader_enabled
	act_linerna_focus()
	if shader_enabled:
		ducto_detras_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		ducto_detras_oscuro.material.set_shader_parameter("shader_enabled", 0.0)

func act_linerna_focus():
	print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Acted focus back duct: ", focus_state.keys()[focus])
	if shader_enabled and focus != focus_state.NONE:
		Foxy.soft_focus_DB = true
		if focus == focus_state.HARD:
			Foxy.hard_focus_DB = true
		else:
			Foxy.hard_focus_DB = false
	else:
		Foxy.hard_focus_DB = false
		Foxy.soft_focus_DB = false

func _on_soft_focus_mouse_entered() -> void:
	focus = focus_state.NONE
	act_linerna_focus()

func _on_soft_focus_mouse_exited() -> void:
	focus = focus_state.SOFT
	act_linerna_focus()

func _on_hard_focus_mouse_entered() -> void:
	focus = focus_state.HARD
	act_linerna_focus()

func _on_hard_focus_mouse_exited() -> void:
	focus = focus_state.SOFT
	act_linerna_focus()
