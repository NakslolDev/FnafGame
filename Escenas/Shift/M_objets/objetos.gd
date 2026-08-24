extends Node2D

@export var randomice := true
@export_enum("0", "1", "2", "3", "4", "5")
var obj := "0"
@export var objects: Array[Node2D]

func _ready():
	for i in objects:
		i.visible = false
	if randomice:
		if randi_range(0, 2) != 0:
			objects.pick_random().visible = true
	elif not obj == "0":
		objects[int(obj)-1].visible = true
