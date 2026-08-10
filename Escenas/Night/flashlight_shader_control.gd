extends Node

const FLASHLIGHT_GROUP_NAME := "FlashlightPNG"
const SHADER: Shader = preload("res://shaders/Pasillo.gdshader")

var nodes: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nodes = get_tree().get_nodes_in_group(FLASHLIGHT_GROUP_NAME)
	for node in nodes:
		var material := ShaderMaterial.new()
		node.material = material
		node.material.shader = SHADER

var shader_enabled: bool = false

func _process(_delta):
	if not shader_enabled:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var mouse = get_viewport().get_mouse_position()

	for node in nodes:
		var mat = node.material
		mat.set_shader_parameter("mouse_pos", mouse)
		mat.set_shader_parameter("viewport_size", viewport_size)

func _on_linterna_linterna_activada_switch(value: bool, _animation: bool) -> void: # animation aqui da igual
	shader_enabled = value
	
	for node in nodes:
		if shader_enabled:
			node.material.set_shader_parameter("shader_enabled", 1.0)
		else:
			node.material.set_shader_parameter("shader_enabled", 0.0)
