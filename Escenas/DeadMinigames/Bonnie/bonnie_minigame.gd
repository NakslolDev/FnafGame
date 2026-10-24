extends Node

@export var character_bonnie: CharacterBody2D
@export var spaceship: Node2D
@export var item_scene: PackedScene
@export var label_points_scene: PackedScene
@export var follow_me: Array[Sprite2D]
@export var block: Array[StaticBody2D]
@export var camera_centers: Array[Node2D]
@export var camera_2d: Camera2D
@export var spawners: Array[Node2D]
@export var foxys: Array[Sprite2D]
@export var fuse_item: CharacterBody2D
var fuse_item_spawned := false

@export var stage1_candy_spawn: Array[Node2D]
@export var stage2_candy_spawn: Array[Node2D]

@export var candy_timer: Timer

@export var power_up_life: Timer
@export var candy_combo_life: Timer
@export var combo_glass: Sprite2D
@export var power_glass: Sprite2D


enum Candy {NONE, RED, ORANGE, BLUE, YELLOW}
enum Pow {NONE, SPEED, JUMP, MAGNET, MORE}

var combo_count: int = 0
var combo: Candy
var power: Pow
var points: int = 0
var stage: int = 1
var combo_life: = 0
var power_life: int = 0
const PHASES := 4

@export var candy: Sprite2D
@export var pw: Sprite2D

signal kill_all()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stage_1_start()

func stage_1_start():
	character_bonnie.locate_to(spawners[0])
	character_bonnie.stop_momentum()
	spaceship.stop()
	
	candy_timer.start()
	
	combo = Candy.NONE
	power = Pow.NONE
	
	combo_life = 0
	power_life = 0
	set_candy()
	set_pow()
	combo_count = 0
	points = 0
	stage = 1
	
	for me in follow_me: me.visible = false
	for wall in block:
		wall.set_collision_layer_value(1,true)
	for fox in foxys: fox.reset()
	camera_2d.global_position = camera_centers[0].global_position

func stage_2_start():
	character_bonnie.locate_to(spawners[1])
	character_bonnie.stop_momentum()
	spaceship.start()
	
	candy_timer.start()
	
	power = Pow.NONE
	
	power_life = 0
	set_pow()
	points = 0
	stage = 2
	
	for me in follow_me: me.visible = false
	for wall in block:
		wall.set_collision_layer_value(1,true)
	for fox in foxys: fox.reset()
	camera_2d.global_position = camera_centers[1].global_position

func stage_3_start():
	spaceship.stop()
	character_bonnie.locate_to(spawners[2])
	character_bonnie.stop_momentum()
	stage = 3
	for me in follow_me: me.visible = false
	for wall in block:
		wall.set_collision_layer_value(1,true)
	for fox in foxys: fox.reset()
	camera_2d.global_position = camera_centers[2].global_position


func set_candy():
	var on: bool = combo != Candy.NONE
	candy.visible = on
	combo_glass.visible = on
	if on:
		candy.frame = combo - 1
		combo_life = PHASES
	combo_count = 0
	combo_glass.frame = 0

func set_pow():
	var on: bool = power != Pow.NONE
	pw.visible = on
	power_glass.visible = on
	if on:
		pw.frame = power - 1
		power_life  = PHASES
		power_up_life.start()
	character_bonnie.power = power
	power_glass.frame = 0


func spawn_item():
	if not fuse_item_spawned and stage == 2 and points >= 1000:
		fuse_item.locate_to(Vector2(randf_range(stage2_candy_spawn[0].position.x, stage2_candy_spawn[1].position.x),randf_range(stage2_candy_spawn[0].position.y, stage2_candy_spawn[1].position.y)))
		fuse_item_spawned = true
		return
	
	var item = item_scene.instantiate()
	add_child(item)

	item.player = character_bonnie

	var position: Vector2
	if stage == 1:
		position = Vector2(randf_range(stage1_candy_spawn[0].position.x, stage1_candy_spawn[1].position.x),randf_range(stage1_candy_spawn[0].position.y, stage1_candy_spawn[1].position.y))
	elif stage == 2:
		position = Vector2(randf_range(stage2_candy_spawn[0].position.x, stage2_candy_spawn[1].position.x),randf_range(stage2_candy_spawn[0].position.y, stage2_candy_spawn[1].position.y))
	item.locate_to(position)

	var powerup: bool = randi_range(0,10) == 0
	if power == Pow.NONE: powerup = randi_range(0,5) == 0
	item.decide_type(combo, powerup)
	if powerup:
		item.collected.connect(pick_powerup)
	else:
		item.collected.connect(pick_candy)
	kill_all.connect(item.kill)

const POINTS_STAGE1 := 1500
const POINTS_STAGE2 := 3000
func pick_candy(type: int, position: Vector2, laser: bool):

	if laser:
		points += 50
		point_label(50, position, false)
		return

	points += 100
	point_label(100, position, false)
	if combo != type:
		combo_life -= 1
		if combo_life <= 0:
			combo = type as Candy
			set_candy()
		else:
			candy_combo_life.start()
			combo_glass.frame += 1
	else:
		combo_count += 1
		candy_combo_life.stop()
		combo_life = PHASES
		combo_glass.frame = 0
	if combo_count != 0 and combo == type:
		points += 50 * combo_count
		point_label(50 * combo_count, position, true)

	if (stage == 1 and points >= POINTS_STAGE1) or (stage == 2 and points >= POINTS_STAGE2):
		stop_stage()

func _on_candy_combo_life_timeout() -> void:
	combo_life -= 1
	if combo_life > 0:
		combo_glass.frame += 1
		candy_combo_life.start()
	else:
		combo = Candy.NONE
		set_candy()



func pick_powerup(type: int, _position: Vector2, laser: bool):
	if laser: return
	power = (int(type) - 4) as Pow
	set_pow()

func _on_power_up_life_timeout() -> void:
	power_life -= 1
	if power_life > 0:
		power_glass.frame += 1
		power_up_life.start()
	else:
		power = Pow.NONE
		set_pow()


const MIN_TIME := 3.0
const MAX_TIME := 5.0
func _on_candy_timer_timeout() -> void:
	spawn_item()
	var time: float = randf_range(MIN_TIME, MAX_TIME)
	if power == Pow.MORE: time = time/1.5
	candy_timer.start(time)

const MAX_HEIGHT := -44.0
func point_label(points_: int, pos: Vector2, combo_: bool):
	if combo_: await get_tree().create_timer(randf_range(0.25,0.75)).timeout
	var label: Node2D = label_points_scene.instantiate()
	var pos_label: Vector2 = pos + Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
	if pos_label.y < MAX_HEIGHT: pos_label.y = MAX_HEIGHT
	label.set_pos(pos_label)
	var text = "+" + str(points_)
	if combo_: text += " Combo!"
	label.set_text(text)
	add_child(label)
	label.start_death_timer(randf_range(1.0,2.0))

func _on_fuse_item_collected(pos: Vector2) -> void:
	Global.dm_unlocks["fuse"] = true
	var label: Node2D = label_points_scene.instantiate()
	var pos_label: Vector2 = pos + Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
	if pos_label.y < MAX_HEIGHT: pos_label.y = MAX_HEIGHT
	label.set_pos(pos_label)
	var text = "@■■■■$item:id:#1281"
	label.set_text(text)
	add_child(label)
	label.start_death_timer(5.0)



func stop_stage():
	spaceship.stop_shoot()
	kill_all.emit()
	candy_timer.stop()
	if combo != Candy.NONE and combo_life != PHASES:
		candy_combo_life.stop()
		combo_life = PHASES
		combo_glass.frame = 0
	for me in follow_me: me.visible = true
	for wall in block:
		wall.set_collision_layer_value(1,false)
	for fox in foxys: fox.start_walk()


func _on_stage_1_body_entered(body: Node2D) -> void:
	if body == character_bonnie:
		stage_2_start()

func _on_stage_2_body_entered(body: Node2D) -> void:
	if body == character_bonnie:
		stage_3_start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		stop_stage()
		return
		await get_tree().physics_frame
		match stage:
			1: stage_2_start()
			2: stage_3_start()
