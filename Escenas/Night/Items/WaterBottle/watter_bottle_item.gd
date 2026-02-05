extends Node2D

signal entered
signal exited

@export var sprites: Array[Sprite2D]
var mouse_in := false

func _ready():
	Items.hydrate.connect(consume) # al hacer que pase por Items, me aseguro de que esta todo sincronizado

func _input(event: InputEvent) -> void:
	if not mouse_in:
		return
	if event.is_action_pressed("Click"):
		Items.consume_water()

func consume():
	if Items.water_bottle == 0:
		#print("hola")
		emit_signal("exited") #saca el raton...
		self.queue_free()

func _on_area_2d_mouse_entered() -> void:
	emit_signal("entered")
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	emit_signal("exited")
	mouse_in = false
