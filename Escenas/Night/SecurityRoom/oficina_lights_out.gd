extends Sprite2D

var shader_enabled := false
@export var lights: Node2D
@export var viñeta: Sprite2D
@export var ruido: Node2D
@onready var ruido_child := ruido.get_children()
@export var ruido_timer: Timer


func _ready():
	Global.energia_actualizada.connect(energia_act)
	visible = lights.light_out_custom
	viñeta.visible = lights.light_out_custom
	ruido.visible = lights.light_out_custom
	ruido_timer.start()

var last: Sprite2D
func _on_ruido_timer_timeout() -> void:
	for child in ruido_child:
		child.visible = false
	var new: Sprite2D = ruido_child.pick_random()
	while new == last:
		new = ruido_child.pick_random()
	new.visible = true
	last = new

func _process(_delta):
	if not visible or not shader_enabled:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var mouse = get_viewport().get_mouse_position()

	var mat = material
	mat.set_shader_parameter("mouse_pos", mouse)
	mat.set_shader_parameter("viewport_size", viewport_size)
	
	var v_mat = viñeta.material
	v_mat.set_shader_parameter("mouse_pos", mouse)
	v_mat.set_shader_parameter("viewport_size", viewport_size)
	
	for child in ruido_child:
		child.material.set_shader_parameter("mouse_pos", mouse)
		child.material.set_shader_parameter("viewport_size", viewport_size)

func energia_act():
	if lights.light_out_custom:
		return
	visible = !Global.energia["Luces"]
	viñeta.visible = !Global.energia["Luces"]
	ruido.visible = !Global.energia["Luces"]

func _on_linterna_linterna_activada_switch(value: bool, _animation: bool) -> void: # animation aqui da igual
	shader_enabled = value
	
	if shader_enabled:
		material.set_shader_parameter("shader_enabled", 1.0)
		viñeta.material.set_shader_parameter("shader_enabled", 1.0)
		ruido.material.set_shader_parameter("shader_enabled", 1.0)
	else:
		material.set_shader_parameter("shader_enabled", 0.0)
		viñeta.material.set_shader_parameter("shader_enabled", 0.0)
		ruido.material.set_shader_parameter("shader_enabled", 0.0)
