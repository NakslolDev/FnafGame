extends Node

const DARK_GROUP_NAME := "FlashlightPNG"
const FLASHLIGHT_GROUP_NAME := "LightPNG"
const BRILLANTE_GROUP_NAME := "Brillantes"
const UI_GROUP_NAME := "FlashlightUI"
const SHADER: Shader = preload("res://shaders/Pasillo.gdshader")
const SHADER_INVERSO: Shader = preload("res://shaders/Luz.gdshader")
const BRILLO_SHADER: Shader = preload("res://shaders/Chroma(Linterna).gdshader")
const SHADER_UI: Shader = preload("res://shaders/UILuz.gdshader")

const FLASHLIGHT_SHADER_PARAMETERS := {
	"radio": 100.0,
	"fade_range": 300.0,
	"transparencia": 0.0,
	"nivel_transparencia": 1.0
}

const LIGHT_SHADER_PARAMETERS := {
	"radio": 350.0,
	"fade_range": 100.0,
	"transparencia": 0.0,
	"nivel_transparencia": 1.0
}

const BRILLANTE_SHADER_PARAMETERS := {
	"radio": 150.0,
	"fade_range": 350.0,
	"transparencia": 1.0,
	"nivel_transparencia": 0.95
}

const UI_SHADER_PARAMETERS := {
	"radio": 75.0,
	"fade_range": 400.0,
	"transparencia": 0.0,
	"nivel_transparencia": 1.0
}

var nodes: Array[Node]
var nodes_flahslight: Array[Node]
var nodes_bright: Array[Node]
var nodes_ui: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	nodes = get_tree().get_nodes_in_group(DARK_GROUP_NAME)
	nodes_flahslight = get_tree().get_nodes_in_group(FLASHLIGHT_GROUP_NAME)
	nodes_bright = get_tree().get_nodes_in_group(BRILLANTE_GROUP_NAME)
	nodes_ui = get_tree().get_nodes_in_group(UI_GROUP_NAME)

	for node in nodes:
		var material := ShaderMaterial.new()
		node.material = material
		node.material.shader = SHADER
		for key in FLASHLIGHT_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, FLASHLIGHT_SHADER_PARAMETERS[key])

	for node in nodes_flahslight:
		var material := ShaderMaterial.new()
		node.material = material
		node.material.shader = SHADER_INVERSO
		for key in LIGHT_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, LIGHT_SHADER_PARAMETERS[key])
		node.visible = false

	for node in nodes_bright:
		var material := ShaderMaterial.new()
		node.material = material
		if "no_chroma" in node and node.no_chroma:
			node.material.shader = SHADER
		else:
			node.material.shader = BRILLO_SHADER
		for key in BRILLANTE_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, BRILLANTE_SHADER_PARAMETERS[key])

	for node in nodes_ui:
		var material := ShaderMaterial.new()
		node.material = material
		node.material.shader = SHADER_UI
		for key in UI_SHADER_PARAMETERS.keys():
			node.material.set_shader_parameter(key, UI_SHADER_PARAMETERS[key])

var shader_enabled: bool = false

func _process(_delta):

	var mouse = get_viewport().get_mouse_position()
	var viewport_size := get_viewport().get_visible_rect().size

	for node in nodes_ui:
		if not node.is_visible_in_tree():
			continue
		var mat = node.material
		if Global.energia["Luces"]:
			mat.set_shader_parameter("active", false)
		else:
			mat.set_shader_parameter("active", true)
			if shader_enabled:
				mat.set_shader_parameter("mouse_pos", shader_original_position(mouse/viewport_size) * viewport_size)# + Vector2(0.0,100.0))
				mat.set_shader_parameter("viewport_size", viewport_size)

	if not shader_enabled:
		return

	for node in nodes:
		if not node.is_visible_in_tree():
			continue
		var mat = node.material
		mat.set_shader_parameter("mouse_pos", mouse)
		mat.set_shader_parameter("viewport_size", viewport_size)

	for node in nodes_flahslight:
		if not node.is_visible_in_tree():
			continue
		var mat = node.material
		mat.set_shader_parameter("mouse_pos", mouse)
		mat.set_shader_parameter("viewport_size", viewport_size)

	for node in nodes_bright:
		if not node.is_visible_in_tree():
			continue
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

	for node in nodes_flahslight:
		if shader_enabled:
			node.visible = true
			node.material.set_shader_parameter("shader_enabled", 1.0)
		else:
			node.visible = false
			node.material.set_shader_parameter("shader_enabled", 0.0)

	for node in nodes_bright:
		if shader_enabled:
			node.material.set_shader_parameter("shader_enabled", 1.0)
		else:
			node.material.set_shader_parameter("shader_enabled", 0.0)

	for node in nodes_ui:
		if shader_enabled:
			node.material.set_shader_parameter("shader_enabled", 1.0)
		else:
			node.material.set_shader_parameter("shader_enabled", 0.0)



const ZOOM: float = 0.2
const SHARPNESS: float = 1.8
const DIRECTION: Vector2 = Vector2(0.0, 1.0) # already unit length

# Computes k = pow(fac1, sharpness) * zoom * 2.0 from the x coordinate,
# which is invariant under the transform (ndir.x == 0).
func _warp_k(x: float) -> float:
	var fac1: float = abs(x - 0.5) * 2.0
	return pow(fac1, SHARPNESS) * ZOOM * 2.0

# Forward: mirrors the shader's fragment() math exactly (pre-wrapping).
# "position" is expected in UV space (0..1), matching SCREEN_UV.
func shader_transformation(position: Vector2) -> Vector2:
	var ndir: Vector2 = DIRECTION.normalized()
	var d: Vector2 = position - Vector2(0.5, 0.5)

	var fac1: float = abs(d.dot(Vector2(ndir.y, ndir.x))) * 2.0
	var fac2: float = -d.dot(ndir) * 2.0

	return position + pow(fac1, SHARPNESS) * fac2 * ZOOM * ndir

# Backward: exact algebraic inverse (valid because DIRECTION == (0,1),
# so x is untouched and the y relationship is linear).
func shader_original_position(position: Vector2) -> Vector2:
	var k: float = _warp_k(position.x)

	# k == 1 would mean division by zero (degenerate case); guard it.
	if is_equal_approx(k, 1.0):
		return position

	var original_y: float = (position.y - 0.5 * k) / (1.0 - k)
	return Vector2(position.x, original_y)
