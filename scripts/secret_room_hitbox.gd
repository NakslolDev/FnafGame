extends TileMapLayer

@export var parent: Node

const duration_fade := 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	act()

func act():
	
	if Global.mapa["door_office_open"]:
		fade_away()

func fade_away():
	
	var tween := create_tween()
	
	tween.tween_property(self, "modulate:a", 0.0, duration_fade)
	tween.finished.connect(func():
		var array = parent.manual_act_nodes
		array.erase(self)
		queue_free()
	)
