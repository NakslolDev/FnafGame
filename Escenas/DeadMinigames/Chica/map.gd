extends Node

@export var main_map: TileMapLayer
@export var start: TileMapLayer
@export var button: TileMapLayer
@export var backstage: TileMapLayer
@export var no_button: TileMapLayer

func _ready() -> void:
	_deactivate(backstage)
	_deactivate(button)

func _activate(tilemap: TileMapLayer):
	tilemap.visible = true
	tilemap.collision_enabled = true

func _deactivate(tilemap: TileMapLayer):
	tilemap.visible = false
	tilemap.collision_enabled = false

func _toggle(tilemap: TileMapLayer):
	if tilemap.visible: _deactivate(tilemap)
	else: _activate(tilemap)


@export var character_chica: CharacterBody2D

func _on_trigger_button_body_entered(body: Node2D) -> void:
	if body != character_chica: return

func _on_activate_button_hall_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(no_button)
	_activate(button)

func _on_deactivate_button_hall_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(button)
	_activate(no_button)
