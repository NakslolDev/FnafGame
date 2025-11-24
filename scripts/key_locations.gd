extends Node2D

func act():
	for node in get_children():
		node.act()
