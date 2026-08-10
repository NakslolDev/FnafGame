extends AnimatedSprite2D

const ANIMATION_NAME := "door"
const EXTENSION := ".png"

@export var frames_file: String
@export var frame_step: int = 1

func _ready():
	var frames = SpriteFrames.new()
	frames.add_animation(ANIMATION_NAME)

	var frame_count := ResourceLoader.list_directory(frames_file).size()
	print("frames: ", frame_count)

	var texture: Texture2D
	for i in (frame_count):
		texture = load(frames_file + str(i * frame_step).pad_zeros(4) + EXTENSION)
		frames.add_frame(ANIMATION_NAME, texture)

	# Set playback settings
	frames.set_animation_loop(ANIMATION_NAME, false)
	frames.set_animation_speed(ANIMATION_NAME, 240.0 / float(frame_step))

	# Assign to the node
	sprite_frames = frames

func close():
	play(ANIMATION_NAME)

func open():
	play_backwards(ANIMATION_NAME)
