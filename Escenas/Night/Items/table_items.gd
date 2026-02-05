extends Node2D

func _ready() -> void:
	if not Global.debug["cheats"]["items"]:
		self.queue_free()
