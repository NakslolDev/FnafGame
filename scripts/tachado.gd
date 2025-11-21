extends Label

@export var id: String
@onready var root_node = get_node("/root/Opciones")
var length = []

func _ready():
	extract_all()
	text = ""
	for num in length:
		for j in range(num):
			text += "―"
		text += "\n"

func extract_all():
	# Separa por espacios y elimina cadenas vacías
	var partes = root_node.get_text(id).split(" ", true)
	# Convierte cada parte a número
	for p in partes:
		length.append(int(p))
