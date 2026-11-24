extends Node

@export var main_map: TileMapLayer
@export var start: TileMapLayer
@export var no_start: TileMapLayer
@export var after_button: TileMapLayer
@export var loop_entrance: TileMapLayer
@export var loop_exit: TileMapLayer
@export var loop_exit_back: TileMapLayer
@export var loop: TileMapLayer
@export var button: TileMapLayer
@export var no_button: TileMapLayer
@export var backstage_entrance: TileMapLayer

func _ready() -> void:
	_deactivate(button)
	_deactivate(loop)
	_deactivate(loop_exit)
	_deactivate(loop_exit_back)
	_deactivate(no_start)
	_deactivate(after_button)
	_deactivate(backstage_entrance)

func _activate(tilemap: TileMapLayer):
	tilemap.visible = true
	tilemap.collision_enabled = true

func _deactivate(tilemap: TileMapLayer):
	tilemap.visible = false
	tilemap.collision_enabled = false

func _toggle(tilemap: TileMapLayer):
	if tilemap.visible: _deactivate(tilemap)
	else: _activate(tilemap)

func _check(tilemap: TileMapLayer) -> bool:
	return tilemap.visible


@export var character_chica: CharacterBody2D

func _on_activate_button_hall_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(no_button)
	_activate(button)

func _on_deactivate_button_hall_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(button)
	_activate(no_button)

func _on_delete_start_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	if _check(start):
		_deactivate(start)
		_activate(no_start)

func _on_trigger_button_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(no_start)
	_activate(after_button)
	_activate(backstage_entrance)

func _on_activate_loop_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(start)
	_deactivate(backstage_entrance)
	_activate(loop)

func _on_activate_loop_exit_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_deactivate(loop_entrance)
	_deactivate(loop_exit_back)
	_activate(loop_exit)

func _on_activate_loop_exit_back_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	if _check(loop_exit):
		_deactivate(loop_exit)
		_activate(loop_exit_back)

func _on_activate_end_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	_activate(backstage_entrance)
	_deactivate(loop)

@export var chica_minigame: Node
func _on_end_body_entered(body: Node2D) -> void:
	if body != character_chica: return
	if _check(backstage_entrance):
		chica_minigame.end_scene()

func free_exit():
	_deactivate(loop_exit_back)

func unfree_exit():
	_activate(loop_exit_back)
