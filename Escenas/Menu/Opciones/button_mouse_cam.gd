extends Button

@export var id_on: String
@export var id_off: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	actualizar(false)

func _on_pressed() -> void:
	actualizar(true)

func actualizar(cambio: bool):
	if cambio:
		Global.mouse_cam_see = !Global.mouse_cam_see
	
	if not Global.mouse_cam_see:
		text = root_node.get_text(id_off)
	else:
		text = root_node.get_text(id_on)
