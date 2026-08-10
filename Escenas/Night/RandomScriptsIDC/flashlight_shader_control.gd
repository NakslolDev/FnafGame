extends Node

const FLASHLIGHT_GROUP_NAME := "FlashlightPNG"
const BRILLANTE_GROUP_NAME := "Brillantes"
const SHADER: Shader = preload("res://shaders/Pasillo.gdshader")
const BRILLO_SHADER: Shader = preload("res://shaders/Chroma(Linterna).gdshader")

const FLASHLIGHT_SHADER_PARAMETERS := {
	"radio": 100.0,
	"fade_range": 300.0,
	"transparencia": 1.0,
	"nivel_transparencia": 0.95
}

const BRILLANTE_SHADER_PARAMETERS := {
	"radio": 150.0,
	"fade_range": 350.0,
	"transparencia": 1.0,
	"nivel_transparencia": 0.95
}

var nodes: Array[Node]
var nodes_bright: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	nodes = get_tree().get_nodes_in_group(FLASHLIGHT_GROUP_NAME)
	nodes_bright = get_tree().get_nodes_in_group(BRILLANTE_GROUP_NAME)

	for node in nodes:
		var material := ShaderMaterial.new()
		node.material = material
		node.material.shader = SHADER
		for key in FLASHLIGHT_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, FLASHLIGHT_SHADER_PARAMETERS[key])

	for node in nodes_bright:
		var material := ShaderMaterial.new()
		node.material = material
		if "no_chroma" in node and node.no_chroma:
			node.material.shader = SHADER
		else:
			node.material.shader = BRILLO_SHADER
		for key in BRILLANTE_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, BRILLANTE_SHADER_PARAMETERS[key])

var shader_enabled: bool = false

func _process(_delta):
	if not shader_enabled:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var mouse = get_viewport().get_mouse_position()

	for node in nodes:
		if not node.visible: continue
		var mat = node.material
		mat.set_shader_parameter("mouse_pos", mouse)
		mat.set_shader_parameter("viewport_size", viewport_size)

	for node in nodes_bright:
		if not node.visible: continue
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

	for node in nodes_bright:
		if shader_enabled:
			node.material.set_shader_parameter("shader_enabled", 1.0)
		else:
			node.material.set_shader_parameter("shader_enabled", 0.0)
