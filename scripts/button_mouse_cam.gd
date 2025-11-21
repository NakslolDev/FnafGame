extends Button

@export var id: String
@onready var root_node = get_node("/root/Opciones")

func _ready():
	text = root_node.get_text(id)
	actualizar(false)

func _on_pressed() -> void:
	actualizar(true)

func actualizar(cambio: bool):
	if cambio:
		Global.mouse_cam_see = !Global.mouse_cam_see
	
	if not Global.mouse_cam_see:
		$Label.visible = true
	else:
		$Label.visible = false
