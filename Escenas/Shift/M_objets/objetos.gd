extends Node2D

@export var randomice := true
@export_enum("0", "1", "2", "3", "4")
var obj := "0"

func _ready():
	if find_children("Things_1") == []:
		return
	for i in range(1, 5):
		get_node("Things_" + str(i)).visible = false
	if randomice:
		if randi_range(0, 2) != 0:
			get_node("Things_" + str(randi_range(1, 4))).visible = true
	elif not obj == "0":
		get_node("Things_" + obj).visible = true
