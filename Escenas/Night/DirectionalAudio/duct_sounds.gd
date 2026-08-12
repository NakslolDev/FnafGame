extends Node

@export var crawling_sounds: Array[spacial_audio]

var playing := false
var last := 0
var volume: int

func _ready():
	Foxy.movement.connect(_movement_foxy)
	Global.energia_actualizada.connect(_lights)
	
	for child in crawling_sounds:
		child.finished.connect(_on_crawling_finished)

func _movement_foxy(pos, room, from_p, from_r):
	
		if room != "Duc5" and from_r != "Duc5" and room != "Duc8" and from_r != "Duc8":
			return
		
		control_volume(pos, room)
		
		aply_volume()
		
		if (room != "Duc5" and room != "Duc8") or pos == 0:
			playing = false
		else:
			if Foxy.flashlight_stunt > 0:
				await Foxy.flashlight_stunt_over
			playing = true
			if (from_r != "Duc5" and from_r != "Duc8") or from_p == 0:
				play()


func play():
	if last == 11:
		last = 1
	else:
		last += 1
	
	var displace := 0 if Foxy.room == "Duc5" else 11
	
	crawling_sounds[last-1+displace].play()

func _on_crawling_finished() -> void:
	if playing:
		play()

func control_volume(pos, room):
	if pos == 0:
		volume = -8
	elif room == "Duc5":
		if pos == 6: # no tengo 3 direcciones...
			volume = -20
		else:
			volume = -15 - abs(3 - pos) * 5 # -15, -20, -25, etc
	elif room == "Duc8":
		volume = -15 - abs(4 - pos) * 5
	if Global.energia["Luces"]:
		volume -= 5
	#print("Volumen = ", volume)

func aply_volume():
	for child in crawling_sounds:
		child._volume = volume - 10
		child.change_volume()

func _lights() -> void:
	control_volume(Foxy.position, Foxy.room)
	aply_volume()
