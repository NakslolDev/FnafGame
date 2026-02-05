extends Node2D

@export var izquierda := true
var shader_enabled := false

var focus := 0

@onready var sprite := $OficinaFondoOscuro

func _ready():
	$Animatronicos/Bonnie.modulate.a = 0.0
	$Animatronicos/Chica.modulate.a = 0.0
	$Animatronicos/Foxy.modulate.a = 0.0
	Bonnie.connect("movement", Callable(self, "movement"))
	Chica.connect("movement", Callable(self, "movement"))
	Foxy.connect("movement", Callable(self, "movement"))

func movement(_a = null, _b = null, _c = null, _d = null):
	if izquierda:
		if Bonnie.position == "PI":
			$Animatronicos/Bonnie.modulate.a = 1.0
		elif Foxy.room == "lhall" and Foxy.position == 0:
			$Animatronicos/Foxy.modulate.a = 1.0
		else:
			$Animatronicos/Bonnie.modulate.a = 0.0
			$Animatronicos/Foxy.modulate.a = 0.0
	else:
		if Chica.position == "PD":
			$Animatronicos/Chica.modulate.a = 1.0
		elif Foxy.room == "rhall" and Foxy.position == 0:
			$Animatronicos/Foxy.modulate.a = 1.0
		else:
			$Animatronicos/Chica.modulate.a = 0.0
			$Animatronicos/Foxy.modulate.a = 0.0

func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	act_linerna_focus()
	if shader_enabled:
		sprite.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		sprite.material.set_shader_parameter("shader_enabled", 0.0)


func act_linerna_focus():
	if izquierda:
		if shader_enabled and focus != 0:
			Bonnie.door_soft_focus = true
			Foxy.soft_focus_I = true
			if focus == 2:
				Foxy.hard_focus_I = true
			else:
				Foxy.hard_focus_I = false
		else:
			Foxy.hard_focus_I = false
			Foxy.soft_focus_I = false
			Bonnie.door_soft_focus = false
	else:
		if shader_enabled and focus != 0:
			Foxy.soft_focus_D = true
			Chica.door_soft_focus = true
			if focus == 2:
				Foxy.hard_focus_D = true
			else:
				Foxy.hard_focus_D = false
		else:
			Foxy.hard_focus_D = false
			Foxy.soft_focus_D = false
			Chica.door_soft_focus = false

func _on_soft_focus_mouse_entered() -> void:
	focus = 1
	act_linerna_focus()

func _on_soft_focus_mouse_exited() -> void:
	focus = 0
	act_linerna_focus()

func _on_hard_focus_mouse_entered() -> void:
	focus = 2
	act_linerna_focus()

func _on_hard_focus_mouse_exited() -> void:
	focus = 1
	act_linerna_focus()
