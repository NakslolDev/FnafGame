extends Node2D

var sounds: Array[spacial_audio] = [] # rellenamos en ready

func _ready() -> void:
	_append_sounds_recursively(self)

func _append_sounds_recursively(father: Node):
	for node in father.get_children():
		if node is spacial_audio:
			sounds.append(node)
		else:
			_append_sounds_recursively(node)

@export var oficina: Node2D

var _local_security_room_position: float

func _physics_process(_delta: float) -> void:
	if _local_security_room_position == oficina.position.x:
		return
	
	_local_security_room_position = oficina.position.x
	
	for audio in sounds:
		audio._change_pos(_local_security_room_position)
