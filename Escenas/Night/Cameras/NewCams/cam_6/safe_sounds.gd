extends Node

@export var timer: Timer
@export var safe_tick: AudioStreamPlayer

var playing := false
var paused := false
var stop_num := 0 # la cantidad de veces que ha parado sin salirte (ej, bajar cámaras)
var remain_combination := [0, 0, 0, 0, 0]
var cicle := 0

func begin():
	
	if (playing and not paused) or not (Chica.position == "6" and (Global.mapa["door_office_open"] and not Global.mapa["safe_open"])):
		return
	playing = true
	
	Chica.watching_cam_6_when_i_am_there_and_door_is_open_and_i_am_attempting_to_open_the_safe = true
	
	if not paused:
		remain_combination = Global.safe_code.duplicate() # duplicate para no referenciar. Sin argumentos pues no es un array complejo...
		cicle = 1
	else:
		remain_combination[cicle - 1] = Global.safe_code[cicle - 1]
	
	timer.start(1.0)
	paused = false


func end(absolute := false):
	if not playing:
		return
	
	timer.stop()
	Chica.watching_cam_6_when_i_am_there_and_door_is_open_and_i_am_attempting_to_open_the_safe = false
	if absolute:
		playing = false
		paused = false
		stop_num = 0
		Chica.tick_count = 0
		Chica.movement_oportunity(true)
	else:
		if stop_num >= 4:
			end(true)
			return
		paused = true
		stop_num += 1
		if Chica.tick_count > 5 * 15:
			Chica.tick_count = 5 * 15


func _on_timer_timeout() -> void:
	
	if not playing or paused:
		return
	
	if remain_combination == [0, 0, 0, 0, 0] or cicle > remain_combination.size():
		end(true)
		return
	
	safe_tick.play()
	
	remain_combination[cicle - 1] -= 1
	if remain_combination[cicle - 1] == 0:
		cicle += 1
		timer.start(1.5)
	else:
		timer.start(randf_range(0.4, 0.8))
