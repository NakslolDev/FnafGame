extends Node

@export var old_sounds := false

var playing := false
var last := 0
var volume: int

func _ready():
	Foxy.connect("movement", Callable(self, "movement_foxy"))
	Global.connect("energia_actualizada", Callable(self, "lights"))
	for child in get_children():
		if str(child).begins_with("CrawlingSeg"):
			child.connect("finished", Callable(self, "_on_crawling_finished"))

func movement_foxy(pos, room, from_p, from_r):
	
		if room != "Duc5" and from_r != "Duc5" and room != "Duc8" and from_r != "Duc8":
			return
		
		control_volume(pos, room)
		
		if old_sounds:
			reproduce()
		else:
			
			aply_volume()
			
			if (room != "Duc5" and room != "Duc8") or pos == 0:
				playing = false
			else:
				if Foxy.flashlight_stunt > 0:
					await Foxy.flashlight_stunt_over
				playing = true
				if (from_r != "Duc5" and from_r != "Duc8") or from_p == 0:
					play()


func reproduce():
	
	var who := randi_range(0, 6)
	while who == last:
		who = randi_range(0, 6)
	last = who
	if who == 1:
		$VentilationLow1.volume_db = volume
		$VentilationLow1.play()
	elif who == 2:
		$VentilationLow2.volume_db = volume
		$VentilationLow2.play()
	elif who == 3:
		$VentilationLow3.volume_db = volume
		$VentilationLow3.play()
	elif who == 4:
		$VentilationLow4.volume_db = volume
		$VentilationLow4.play()
	elif who == 5:
		$VentilationLow5.volume_db = volume
		$VentilationLow5.play()
	elif who == 6:
		$VentilationLow6.volume_db = volume
		$VentilationLow6.play()


func play():
	if last == 11:
		last = 1
	else:
		last += 1
	get_node("CrawlingSeg" + str(last)).play()

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
		volume -= 7
	#print("Volumen = ", volume)

func aply_volume():
	for child in get_children():
		if str(child).begins_with("Crawling"):
			child.volume_db = volume - 12

func lights() -> void:
	control_volume(Foxy.position, Foxy.room)
	aply_volume()
