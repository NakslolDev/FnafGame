extends Node

signal consume_batteries
signal hydrate

var water_bottle: int
const WATER_STRENGHT := 300
const WATERING_TIME := 15.0
var batteries: int

func night_starts(): # Completamente temporal
	
	batteries = 0
	water_bottle = 0
	
	for i in range(randi_range(2,3)):
		if randi_range(0,2) == 0 and water_bottle == 0:
			water_bottle += 1
			print("one water")
		else:
			batteries += 1
			print("one battery")
	print("total of ", batteries, " batteries, ", water_bottle, " watters, ")
	emit_signal("consume_batteries") # actualiza las baterias
	emit_signal("hydrate") # actualiza las aguas


func consume_battery():
	if batteries == 0: return
	batteries -= 1
	emit_signal("consume_batteries")
	print("sweet succulent double A batteries")

func consume_water():
	if water_bottle == 0: return
	water_bottle -= 1
	emit_signal("hydrate")
	print("ts is lacking some Guacamole Gamer Fart 9000")
	
	var start := Global.insanity
	var end: int = max(Global.insanity - WATER_STRENGHT, -100)

	var tween := create_tween()
	tween.tween_method(
		func(value): Global.insanity = int(value),
		start,
		end,
		WATERING_TIME
	)
