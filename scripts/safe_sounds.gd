extends Node

var playing := false
var stop := false
var stop_num := 0
var remain_combination := [0, 0, 0, 0, 0]
var cicle := 0

func begin():
#	print("BEGIN COMBINATION")
	
	if (playing and not stop) or not (Chica.position == "6" and (Global.noche == 5 and Global.mapa["door_office_open"] and not Global.mapa["safe_open"])):
#		print("Nevermind")
		return
	playing = true
	
	Chica.watching_cam_6_when_i_am_there_and_it_is_night_5_and_i_am_attempting_to_open_the_safe = true
	
	if not stop:
		remain_combination = Global.safe_code.duplicate() # duplicate para no referenciar. Sin argumentos pues no es un array complejo...
		cicle = 1
	else:
		remain_combination[cicle - 1] = Global.safe_code[cicle - 1]
	
	$Timer.start(1.0)
	stop = false


func end(absolute := false):
#	print("STOP COMBINATION")
	
	if not playing:
		return
	
	Chica.watching_cam_6_when_i_am_there_and_it_is_night_5_and_i_am_attempting_to_open_the_safe = false
	if absolute:
#		print("ABSOLUTE")
		playing = false
		stop = false
		stop_num = 0
		Chica.tick_count = 0
		Chica.movement_oportunity(Global.noche, Chica.AI_level, true)
	else:
#		print("Temporal")
		if stop_num >= 4:
			end(true)
		stop = true
		stop_num += 1
		if Chica.tick_count > 5 * 15:
			Chica.tick_count = 5 * 15


func _on_timer_timeout() -> void:
	
	if not playing or stop:
		return
	
	if remain_combination == [0, 0, 0, 0, 0]:
		end(true)
		return
	
	$safe_tick.play()
	
	remain_combination[cicle - 1] -= 1
	if remain_combination[cicle - 1] == 0:
		cicle += 1
		$Timer.start(1.5)
	else:
		$Timer.start(randf_range(0.4, 0.8))
