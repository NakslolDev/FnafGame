extends Node

var active := false
var playing := false
var group := 1
var each := 1

func _ready():
	Chica.connect("movement", Callable(self, "movement_chica"))

func act_playing():
	if not (active and not playing):
		return
	
	var rand_chance: int
	if group == 1 or group == 2:
		rand_chance = randi_range(0, 3)
	elif group == 3:
		rand_chance = randi_range(0, 1)
	else:
		rand_chance = 0
	
	if rand_chance == 0:
		var prev_group := group
		while prev_group == group:
			if randi_range(0, 20) == 0:
				group = randi_range(1, 4)
			else:
				group = randi_range(1, 3)
		
		
	
	else:
		var prev_each := each
		while prev_each == each:
			if group == 1 or group == 2:
				each = randi_range(1, 4)
			elif group == 3:
				each = randi_range(1, 3)
			else:
				each = 1
	
	if rand_chance != 0:
		play()
	else:
		$change.start()

func _on_change_timeout() -> void:
	play()

func play():
	playing = true
	if group == 1:
		if each == 1:
			$Searching_1/Searching01.play()
		elif each == 2:
			$Searching_1/Searching02.play()
		elif each == 3:
			$Searching_1/Searching03.play()
		elif each == 4:
			$Searching_1/Searching04.play()
	elif group == 2:
		if each == 1:
			$Searching_2/Searching05.play()
		elif each == 2:
			$Searching_2/Searching06.play()
		elif each == 3:
			$Searching_2/Searching07.play()
		elif each == 4:
			$Searching_2/Searching08.play()
	elif group == 3:
		if each == 1:
			$Hitting/Hitting01.play()
		elif each == 2:
			$Hitting/Hitting02.play()
		else:
			$Hitting/Hitting03.play()
	elif group == 4:
		$BigCrash.play()

func stop_playing():
	$Searching_1/Searching01.stop()
	$Searching_1/Searching02.stop()
	$Searching_1/Searching03.stop()
	$Searching_1/Searching04.stop()
	$Searching_2/Searching05.stop()
	$Searching_2/Searching06.stop()
	$Searching_2/Searching07.stop()
	$Searching_2/Searching08.stop()
	$Hitting/Hitting01.stop()
	$Hitting/Hitting02.stop()
	$Hitting/Hitting03.stop()
	$BigCrash.stop()

func movement_chica(_to, from):
	if from == "6":
		stop_playing()

func _on_searching_01_finished() -> void:
	playing = false
	act_playing()
func _on_searching_02_finished() -> void:
	playing = false
	act_playing()
func _on_searching_03_finished() -> void:
	playing = false
	act_playing()
func _on_searching_04_finished() -> void:
	playing = false
	act_playing()
func _on_searching_05_finished() -> void:
	playing = false
	act_playing()
func _on_searching_06_finished() -> void:
	playing = false
	act_playing()
func _on_searching_07_finished() -> void:
	playing = false
	act_playing()
func _on_searching_08_finished() -> void:
	playing = false
	act_playing()
func _on_hitting_01_finished() -> void:
	playing = false
	act_playing()
func _on_hitting_02_finished() -> void:
	playing = false
	act_playing()
func _on_hitting_03_finished() -> void:
	playing = false
	act_playing()
func _on_big_crash_finished() -> void:
	playing = false
	act_playing()
