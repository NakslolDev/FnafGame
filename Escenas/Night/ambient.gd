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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Bonnie.movement.connect(sync)
	Chica.movement.connect(sync)
	Freddy.movement.connect(sync)
	Foxy.movement.connect(sync)
	sync()

func sync(_a = null, _b = null, _c = null, _d = null) -> void:
	low_ambient.play()
	
	_reset_foxy_warn()

const FOXY_CHANCE_TO_AMBIENT_SOUND := 120
var foxy_warn := false
func _on_tick_timeout() -> void:
	if foxy_warn: return
	if randi_range(0,FOXY_CHANCE_TO_AMBIENT_SOUND) != 0: return

	if Foxy.room == "Duc5" or Foxy.room == "Duc8" or Foxy.room == "rhall" or Foxy.room == "lhall":
		metal_grindin.pitch_scale = randf_range(0.5,1.0)
		metal_grindin.play()
		foxy_warn = true

func _reset_foxy_warn():
	if not (Foxy.room == "Duc5" or Foxy.room == "Duc8" or Foxy.room == "rhall" or Foxy.room == "lhall") or randi_range(0,20) == 0:
		foxy_warn = false
