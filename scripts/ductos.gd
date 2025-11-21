extends Node2D

var shader_enabled := false
var focus := 0

func _ready():
	$Foxy.modulate.a = 0.0
	Foxy.connect("movement", Callable(self, "movement"))

func movement(_a = null, _b = null, _c = null, _d = null):
	if Foxy.room == "Duc5" and Foxy.position == 0:
		$Foxy.modulate.a = 1.0
	else:
		$Foxy.modulate.a = 0.0

@onready var sprite := $DuctosFondoOscuro
	
func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	act_linerna_focus()
	if shader_enabled:
		sprite.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		sprite.material.set_shader_parameter("shader_enabled", 0.0)


func act_linerna_focus():
	if shader_enabled and focus != 0:
		Foxy.soft_focus_DF = true
		if focus == 2:
			Foxy.hard_focus_DF = true
		else:
			Foxy.hard_focus_DF = false
	else:
		Foxy.hard_focus_DF = false
		Foxy.soft_focus_DF = false

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
