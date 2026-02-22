extends Node

signal act_objects

var objects = {
	"water_bottle": 3,
	"batteries": 3,
}

#methods---

#batteries

signal recharge_flashlight

func consume_batteries():
	if objects["batteries"] == 0: return
	
	objects["batteries"] -= 1
	recharge_flashlight.emit()
	act_objects.emit()
	print("sweet succulent double A batteries")

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
