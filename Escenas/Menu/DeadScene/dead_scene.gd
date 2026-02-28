extends Node2D

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

var type := 0

@export var advice: Label

@export var timer: Timer

const MINIMUN_TIME := 2.0

var can_trans := false

func _ready():
	type = Global.dead_scene_type
	act_sprites()
	advice.act_advice(type)
	
	timer.start(MINIMUN_TIME)

func _on_timer_timeout() -> void:
	can_trans = true

func _input(event: InputEvent) -> void:
	if not can_trans:
		return
	if event.is_action_pressed("Click") or event.is_action_pressed("Enter") or event.is_action_pressed("Esc") or event.is_action_pressed("Space") or event.is_action_pressed("interact"):
		exit()


func act_sprites():
	$Imagen/Fan.visible = false
	$Imagen/Bonnie.visible = false
	$Imagen/Chica.visible = false
	$Imagen/Freddy.visible = false
	$Imagen/Foxy.visible = false
	
	if type == 0:
		$Imagen/Fan.visible = true
	if type == 1:
		$Imagen/Bonnie.visible = true
	if type == 2:
		$Imagen/Chica.visible = true
	if type == 3:
		$Imagen/Freddy.visible = true
	if type == 4:
		$Imagen/Foxy.visible = true

func exit():
	if Global.noche == 0:
		if Global.misc["When_dead_go_to"] == "night":
			scene_handler.trans_to_scene(scene_handler.scene.NIGHT)
		else:
			scene_handler.trans_to_scene(scene_handler.scene.CUSTOM_NIGHT)
	else:
		if Global.misc["When_dead_go_to"] == "night":
			scene_handler.trans_to_scene(scene_handler.scene.NIGHT)
		elif Global.misc["When_dead_go_to"] == "shift":
			scene_handler.trans_to_scene(scene_handler.scene.SHIFT)
		else:
			scene_handler.trans_to_scene(scene_handler.scene.MAIN_MENU)
