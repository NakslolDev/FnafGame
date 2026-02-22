extends Node2D
class_name consumable


@export var object_name: String
@export var maximun: int = 3
@export_category("Nodes")
@export var sprites: Array[Sprite2D]
@export var colliders: Array[CollisionShape2D]
@export var area: Area2D

func _ready():
	Items.act_objects.connect(_act)
	
	_validate()
	
	_act()

func _validate():
	if sprites.size() == 0:
		push_error("You need sprites in ", self)
	else:
		for sprite in sprites:
			if sprite == null:
				push_error("You have a null sprite in ", self)
	
	if colliders.size() == 0:
		push_error("You need colliders in ", self)
	else:
		for colition in colliders:
			if colition == null:
				push_error("You have a null colider in ", self)
	
	if area == null:
		push_error("You need an area in ", self)
	else:
		area.add_to_group("interactable")
	
	if not Items.objects.has(object_name):
		push_warning("There is no ", object_name, " in ", self)
	
	if Items.objects[object_name] > maximun:
		push_warning("There are too many of ", object_name, " in ", self)
		Items.objects[object_name] = maximun

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("Click") or not _is_mouse_over():
		return
	
	_consume()

func _is_mouse_over() -> bool:
	for overlaping_areas in area.get_overlapping_areas():
			if str(overlaping_areas).begins_with("MouseHitbox"):
				return true
	return false

func _consume():
	if Items.has_method("consume_" + object_name):
		Items.call("consume_" + object_name)
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "consumed: ", object_name)
	else:
		push_error("Items doesnt have method called consume_", object_name, "for object ", self)

func _act():
	var quantity: int = Items.objects[object_name]
	
	if quantity == 0:
		self.queue_free() #elimina el nodo entero, pues ya no van a haber más
	
	for colition in colliders:
		colition.disabled = true
	colliders[quantity -1].disabled = false
	
	for sprite in sprites:
		sprite.visible = false
	sprites[quantity -1].visible = true
