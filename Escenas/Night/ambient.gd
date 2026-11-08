extends Node

@export var all: Array[AudioStreamPlayer]
@export var deepnest_be_like: AudioStreamPlayer
@export var deep_ambient: AudioStreamPlayer
@export var fallout: AudioStreamPlayer
@export var high_ambient: AudioStreamPlayer
@export var high_pitch: AudioStreamPlayer
@export var high_pitch_texture: AudioStreamPlayer
@export var low_ambient: AudioStreamPlayer
@export var metal_grindin: AudioStreamPlayer
@export var strange_noises: AudioStreamPlayer
@export var strange_ambient: AudioStreamPlayer
@export var someone_at_the_door: AudioStreamPlayer
@export var commotion: AudioStreamPlayer

@export var soul_1: AudioStreamPlayer
@export var soul_2: AudioStreamPlayer
@export var soul_main: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(SOUL_VOLUME)
	Bonnie.movement.connect(sync)
	Bonnie.movement.connect(movement_bonnie)
	Chica.movement.connect(sync)
	Chica.movement.connect(movement_chica)
	Freddy.movement.connect(sync)
	Freddy.movement.connect(movement_freddy)
	Foxy.movement.connect(sync)
	Foxy.movement.connect(movement_foxy)
	sync()
	low_ambient.play()

##tick

const FOXY_CHANCE_TO_AMBIENT_SOUND := 120
var foxy_warn := false
func _on_tick_timeout() -> void:
	foxy()

##movement

func sync(_a = null, _b = null, _c = null, _d = null) -> void:
	pass

func movement_bonnie(_a = null, _b = null, _c = null, _d = null):
	if Bonnie.position != "PI":
		bonnie_spotted = false
	_check_door_empty()

func movement_chica(_a = null, _b = null, _c = null, _d = null):
	if Chica.position != "PD":
		chica_spotted = false
	_check_door_empty()

func _check_door_empty():
	if commotion_playing and Chica.position != "PD" and Bonnie.position != "PI":
		deactivate_commotion()

func movement_freddy(_a = null, _b = null, _c = null, _d = null):
	pass

func movement_foxy(_a = null, _b = null, _c = null, _d = null):
	_reset_foxy_warn()
	soul()

##foxy random ambient

func foxy():
	if foxy_warn: return
	if randi_range(0,FOXY_CHANCE_TO_AMBIENT_SOUND) != 0: return

	if Foxy.room == "Duc5" or Foxy.room == "Duc8" or Foxy.room == "rhall" or Foxy.room == "lhall":
		metal_grindin.pitch_scale = randf_range(0.5,1.0)
		metal_grindin.play()
		foxy_warn = true

func _reset_foxy_warn():
	if not (Foxy.room == "Duc5" or Foxy.room == "Duc8" or Foxy.room == "rhall" or Foxy.room == "lhall") or randi_range(0,20) == 0:
		foxy_warn = false

##door commotion

@export var pasillo_izquierdo: Node2D
@export var pasillo_derecho: Node2D

const COMMOTION_DB := -10.0
const FAST := true
const SLOW := false
const ACTIVATE_TIME := 3.0
const DEACTIVATE_TIME := 5.0
const DOOR_OVERRIDE_TIME := 1.0

var commotion_playing := false
var deactivating_commotion := false
var commotion_tween: Tween

var chica_spotted := false
var bonnie_spotted := false

func _on_pasillo_izquierdo_hard_focus_mouse_enter() -> void:
	if seeing_someone_at_door():
		commotion_sound()

func _on_pasillo_derecho_hard_focus_mouse_enter() -> void:
	if seeing_someone_at_door():
		commotion_sound()

const IGNORE_FLASHLIGHT := true
func _on_linterna_linterna_activada_switch(on: bool, _animation: bool) -> void:
	if not on: return
	if seeing_someone_at_door(IGNORE_FLASHLIGHT): # pasillo recive su informacion de flashlight con la misma señal, por lo que todavia no esta sincronizada
		commotion_sound()

func seeing_someone_at_door(ignore_flashlight: bool = false) -> bool:
	var see: bool = false
	if Chica.position == "PD" and not chica_spotted:
		if pasillo_derecho.get_focus_state(ignore_flashlight) == 2 and not Chica.door_closed:
			see = true
			chica_spotted = true
	if Bonnie.position == "PI" and not bonnie_spotted:
		if pasillo_izquierdo.get_focus_state(ignore_flashlight) == 2 and not Bonnie.door_closed:
			see = true
			bonnie_spotted = true
	return see

func _on_camaras_cam_action(cam: int, flashlight: bool) -> void:
	if not flashlight: return
	if Chica.position == "PD" and not chica_spotted:
		if cam == 13:
			commotion_sound()
			chica_spotted = true
	if Bonnie.position == "PI" and not bonnie_spotted:
		if cam == 11:
			commotion_sound()
			bonnie_spotted = true


func commotion_sound():
	if soul_main.playing:
		only_commotion_sfx()
		return

	if commotion_playing:
		only_commotion_sfx()
		if deactivating_commotion:
			cancel_door_deactivation()
	else:
		activate_commotion(FAST)

func only_commotion_sfx():
	var should_play: bool = (soul_main.playing or someone_at_the_door.playing)
	if should_play and not commotion.playing:
		commotion.play()

func _new_door_tween() -> Tween:
	if commotion_tween and commotion_tween.is_valid():
		commotion_tween.kill()
	commotion_tween = create_tween()
	return commotion_tween

func activate_commotion(fast: bool):
	if commotion_playing: return
	commotion_playing = true
	someone_at_the_door.play()
	if fast:
		someone_at_the_door.volume_db = COMMOTION_DB
		return
	someone_at_the_door.volume_db = -80.0
	_new_door_tween().tween_property(someone_at_the_door, "volume_db", COMMOTION_DB, ACTIVATE_TIME)

func deactivate_commotion(time := DEACTIVATE_TIME):
	if deactivating_commotion or not commotion_playing: return
	deactivating_commotion = true
	var tween := _new_door_tween() # también mata un fade-in en curso
	tween.tween_property(someone_at_the_door, "volume_db", -80.0, time)
	await tween.finished # si se cancela, nunca llega y se salta el stop()
	someone_at_the_door.stop()
	commotion_playing = false
	deactivating_commotion = false

func cancel_door_deactivation():
	if commotion_tween and commotion_tween.is_valid():
		commotion_tween.kill()
	deactivating_commotion = false
	someone_at_the_door.volume_db = COMMOTION_DB

##foxy attacking

const SOUL_VOLUME := -20.0
const SOUL_SPEED := 0.5

var soul_tween: Tween
var soul_target_db := INF
var soul_fading_out := false

func soul_should_start() -> bool:
	return Foxy.position == 0 and (Foxy.room == "rhall" or Foxy.room == "lhall" or Foxy.room == "Duc5" or Foxy.room == "Duc8")

func soul_should_stay() -> bool:
	return (Foxy.position == 0 and (Foxy.room == "rhall" or Foxy.room == "lhall")) or Foxy.room == "Duc5" or Foxy.room == "Duc8"

func soul():
	if soul_main.playing and not soul_fading_out:
		if soul_should_stay():
			manage_soul()
		else:
			deactivate_soul()
	elif soul_should_start():
		activate_soul()

func soul_distance() -> int:
	if Foxy.position == 0: return 0
	elif Foxy.room == "Duc5":
		return 3 if Foxy.position == 6 else 1 + abs(Foxy.position - 3)
	elif Foxy.room == "Duc8":
		return 1 + abs(Foxy.position - 4)
	return 0 #no deveria de llegar nunca aqui, pero bueno

func _new_soul_tween() -> Tween:
	if soul_tween and soul_tween.is_valid():
		soul_tween.kill()
	soul_tween = create_tween()
	return soul_tween

func manage_soul():
	var target := SOUL_VOLUME - soul_distance() * 5
	if is_equal_approx(target, soul_target_db): return
	soul_target_db = target
	_new_soul_tween().tween_property(soul_main, "volume_db", target, SOUL_SPEED)

func activate_soul():
	if commotion_playing and not deactivating_commotion:
		deactivate_commotion(DOOR_OVERRIDE_TIME)
	soul_fading_out = false
	soul_target_db = SOUL_VOLUME
	if not soul_main.playing:
		soul_main.volume_db = -80.0
		soul_main.play()
	_new_soul_tween().tween_property(soul_main, "volume_db", SOUL_VOLUME, ACTIVATE_TIME)

func deactivate_soul():
	if soul_fading_out: return
	soul_fading_out = true
	soul_target_db = INF
	_new_soul_tween().tween_property(soul_main, "volume_db", -80.0, DEACTIVATE_TIME)
	await soul_tween.finished
	soul_main.stop()
	soul_main.volume_db = 0.0
	soul_fading_out = false
