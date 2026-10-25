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
	low_ambient.play()
