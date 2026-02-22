extends Node2D

@export var sprites: Array[Sprite2D]
var mouse_in := false
@export var area_2d: Area2D


func _ready():
	Items.consume_batteries.connect(consume) # al hacer que pase por Items, me aseguro de que esta todo sincronizado
	area_2d.add_to_group("interactable")

func _input(event: InputEvent) -> void:
	if not mouse_in:
		return
	if event.is_action_pressed("Click"):
		Items.consume_battery()

func consume():
	
	for n in sprites.size():
		if Items.batteries < n+1:
			sprites[n].visible = false
	
	if Items.batteries == 0:
		self.queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
