extends Sprite2D


func _process(_delta):
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse = get_viewport().get_mouse_position()

	var mat = material
	mat.set_shader_parameter("mouse_pos", mouse)
	mat.set_shader_parameter("viewport_size", viewport_size)
