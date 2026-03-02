extends Node2D

@export var izquierda := true
var shader_enabled := false

enum focus_state {NONE, SOFT, HARD}
var focus: focus_state = focus_state.NONE

@export var bonnie: Sprite2D
@export var chica: Sprite2D
@export var foxy: Sprite2D

@export var oficina_fondo_oscuro: Sprite2D

func _ready():
	bonnie.modulate.a = 0.0
	chica.modulate.a = 0.0
	foxy.modulate.a = 0.0
	Bonnie.movement.connect(movement)
	Chica.movement.connect(movement)
	Foxy.movement.connect(movement)

func movement(_a = null, _b = null, _c = null, _d = null):
	if izquierda:
		if Bonnie.position == "PI":
			bonnie.modulate.a = 1.0
		elif Foxy.room == "lhall" and Foxy.position == 0:
			foxy.modulate.a = 1.0
		else:
			bonnie.modulate.a = 0.0
			foxy.modulate.a = 0.0
	else:
		if Chica.position == "PD":
			chica.modulate.a = 1.0
		elif Foxy.room == "rhall" and Foxy.position == 0:
			foxy.modulate.a = 1.0
		else:
			chica.modulate.a = 0.0
			foxy.modulate.a = 0.0

func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	act_linerna_focus()
	if shader_enabled:
		oficina_fondo_oscuro.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		oficina_fondo_oscuro.material.set_shader_parameter("shader_enabled", 0.0)


func act_linerna_focus():
	if izquierda:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Acted focus left door: ", focus_state.keys()[focus])
		if shader_enabled and focus != focus_state.NONE:
			Bonnie.door_soft_focus = true
			Foxy.soft_focus_I = true
			if focus == focus_state.HARD:
				Foxy.hard_focus_I = true
			else:
				Foxy.hard_focus_I = false
		else:
			Foxy.hard_focus_I = false
			Foxy.soft_focus_I = false
			Bonnie.door_soft_focus = false
	else:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Acted focus right door: ", focus_state.keys()[focus])
		if shader_enabled and focus != focus_state.NONE:
			Foxy.soft_focus_D = true
			Chica.door_soft_focus = true
			if focus == focus_state.HARD:
				Foxy.hard_focus_D = true
			else:
				Foxy.hard_focus_D = false
		else:
			Foxy.hard_focus_D = false
			Foxy.soft_focus_D = false
			Chica.door_soft_focus = false

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
