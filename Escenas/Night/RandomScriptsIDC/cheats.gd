extends Node2D

@export var get_from_global := true
@export var invencibility := false
@export var infinite_light := false
@export var see_light_batery := false
@export var max_consumption := 3
@export var lights_consume := false
@export var tick_rate := 5
@export var tick_count := false
@export var bosque_escarlata := false
@export var animatronic_map := false
@export var night_duration := 5
@export var see_time_always := false
@export var see_insanity := false
@export var timeless := false


func _ready():
	
	get_global_values()
	
	if max_consumption == 0:
		Global.energia_consumption["Max"] = INF
	else:
		Global.energia_consumption["Max"] = max_consumption
	
	Global.timeless = timeless
	$"../True_No_Shader/Animatronic_Map".visible = animatronic_map
	Global.energia_consumption["Lights_Consume"] = lights_consume
	$"../True_No_Shader/VBoxContainer/Time_label".visible = see_time_always
	$"../True_No_Shader/VBoxContainer/Insanity_label".visible = see_insanity
	Global.night_speed = night_duration
	$"../Oficina/VHS_Player".scarlet_forest = bosque_escarlata

func get_global_values():
	if not get_from_global:
		return
	for key in Global.debug["cheats"]:
		set(key, Global.debug["cheats"][key])
		bosque_escarlata = false

func _physics_process(_delta):
	if infinite_light:
		Global.linterna_bateria = 100
