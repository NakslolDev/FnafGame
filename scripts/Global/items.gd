extends Node

signal act_objects

var objects = {
	"water_bottle": 0, # consumible
	"batteries": 0, # consumible
	"door_toy": 0,
	"left_door_toy": false,
	"right_door_toy": false,
}

func night_starts():
	if Global.noche == 0: reset()
	act_objects.emit()

func reset():
	objects = {
		"water_bottle": 0,
		"batteries": 0,
		"door_toy": 0,
		"left_door_toy": true,
		"right_door_toy": true,
	}
	drinking = false
	left_usage = 0
	right_usage = 0

func _ready():
	Bonnie.movement.connect(_movement_bonnie)
	Chica.movement.connect(_movement_chica)
	Foxy.movement.connect(_movement_foxy)


#batteries

signal recharge_flashlight

func consume_batteries():
	if objects["batteries"] == 0: return
	
	objects["batteries"] -= 1
	
	Global.linterna_bateria += BATTERY_RECHARGE #linterna bateria ya tiene su propio clamp
	
	recharge_flashlight.emit()
	act_objects.emit()
	print("sweet succulent double A batteries")

const BATTERY_RECHARGE := 50

#water bottle

var drinking: bool = false

func consume_water_bottle():
	if objects["water_bottle"] == 0: return
	
	if drinking: return
	
	objects["water_bottle"] -= 1
	drinking = true
	act_objects.emit()
	_hydrate_from_water_bottle()
	print("ts is lacking some Guacamole Gamer Fart 9000")

const WATER_STRENGHT := 300
const WATERING_TIME := 15.0
func _hydrate_from_water_bottle():
	var start := Global.insanity
	var end: int = max(Global.insanity - WATER_STRENGHT, -100)
	var time: float = WATERING_TIME * (start - end) / WATER_STRENGHT
	
	var tween := create_tween()
	tween.tween_method(
		func(value): Global.insanity = int(value),
		start,
		end,
		time
	)
	tween.tween_callback(
		func(): drinking = false
	)

# door toy

func _movement_bonnie(to: String, from: String):
	if to == "PI" and not from == "PI":
		_press_toy_left()

func _movement_chica(to: String, from: String):
	if to == "PD" and not from == "PD":
		_press_toy_right()

func _movement_foxy(to_pos: int, to_room: String, from_pos: int, from_room: String):
	if to_pos == 0 and to_room == "lhall" and not (from_pos == 0 and from_room == "lhall"):
		_press_toy_left()
	elif to_pos == 0 and to_room == "rhall" and not (from_pos == 0 and from_room == "rhall"):
		_press_toy_right()


signal left_toy_squeek
var left_usage := 0
func _press_toy_left():
	if not objects["left_door_toy"]: return
	
	if _probability_of_break(left_usage):
		objects["left_door_toy"] = false
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Left toy broke :(")
	else:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Left toy squeeck")
	
	left_usage += 1
	left_toy_squeek.emit()

signal right_toy_squeek
var right_usage := 0
func _press_toy_right():
	if not objects["right_door_toy"]: return
	
	if _probability_of_break(right_usage):
		objects["right_door_toy"] = false
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Right toy broke :(")
	else:
		print(Global.time_hour, ":", str(Global.time_minute).pad_zeros(2), " - ", "Right toy squeeck")

	right_usage += 1
	right_toy_squeek.emit()


func _probability_of_break(use: int) -> bool: # esta formula la he conseguido despues de bastante prueba y error. Al final es extremadamente sencilla, pero bueno
	if randf() > (use + 1)/8.0:
		return false
	else:
		return true

func _test_probability():
	var sum := 0
	var number: Array[float] = [0,0,0,0,0,0,0,0,0,0,0]
	for i in 1000:
		for n in 10:
			if _probability_of_break(n):
				print("broke on ", n)
				sum += n
				number[n] += 1
				break
			elif n == 9:
				print("didnt break")
				sum += 10
	print("Resultados: ", number)
	for n in 10:
		number[n] *= 1.0/1000.0
	print("Porcentajes: ", number)
	print("Media es de ", sum / 1000.0)
	# Resultados: [123.0, 232.0, 250.0, 180.0, 117.0, 75.0, 20.0, 3.0, 0.0, 0.0, 0.0]
	# Porcentajes: [0.123, 0.232, 0.25, 0.18, 0.117, 0.075, 0.02, 0.003, 0.0, 0.0, 0.0]
	# Media es de 2.256 # ~3er uso
