extends Sprite2D

var shader_enabled := false
@export var lights: Node2D
@export var viñeta: Sprite2D
@export var ruido: Sprite2D



func _ready():
	Global.energia_actualizada.connect(energia_act)
	if lights.light_out_custom:
		visible = true
		viñeta.visible = true
		ruido.visible = true
	else:
		visible = false
		viñeta.visible = false
		ruido.visible = false

func _process(_delta):
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse = get_viewport().get_mouse_position()

	var mat = material
	mat.set_shader_parameter("mouse_pos", mouse)
	mat.set_shader_parameter("viewport_size", viewport_size)
	
	var v_mat = viñeta.material
	v_mat.set_shader_parameter("mouse_pos", mouse)
	v_mat.set_shader_parameter("viewport_size", viewport_size)
	
	var r_mat = ruido.material
	r_mat.set_shader_parameter("mouse_pos", mouse)
	r_mat.set_shader_parameter("viewport_size", viewport_size)

func energia_act():
	if lights.light_out_custom:
		return
	if Global.energia["Luces"]:
		visible = false
		viñeta.visible = false
		ruido.visible = false
	else:
		visible = true
		viñeta.visible = true
		ruido.visible = true

func _on_linterna_linterna_activada_switch() -> void:
	shader_enabled = !shader_enabled
	
	if shader_enabled:
		material.set_shader_parameter("shader_enabled", 1.0)
		viñeta.material.set_shader_parameter("shader_enabled", 1.0)
		ruido.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		material.set_shader_parameter("shader_enabled", 0.0)
		viñeta.material.set_shader_parameter("shader_enabled", 0.0)
		ruido.material.set_shader_parameter("shader_enabled", 0.0)
