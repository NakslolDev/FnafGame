extends Node

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


@export_category("nodes")
@export var tick_label: Label
@export var batery_label: Label
@export var time_label: Label
@export var insanity_label: Label
@export var animatronic_map_node: Node2D
@export var vhs_player: Node2D


func _ready():
	
	get_global_values()
	
	if max_consumption == 0:
		Global.energia_consumption["Max"] = INF
	else:
		Global.energia_consumption["Max"] = max_consumption
	
	Global.timeless = timeless
	animatronic_map_node.visible = animatronic_map
	animatronic_map_node.act_first()
	Global.energia_consumption["Lights_Consume"] = lights_consume
	time_label.visible = see_time_always
	insanity_label.visible = see_insanity
	Global.night_speed = night_duration
	vhs_player.scarlet_forest = bosque_escarlata
	
	if not see_light_batery: batery_label.visible = false
	

func get_global_values():
	if not get_from_global:
		return
	for key in Global.debug["cheats"]:
		set(key, Global.debug["cheats"][key])
		bosque_escarlata = false

func _process(delta: float) -> void:
	
	if infinite_light:
		Global.linterna_bateria = 100
	
	if tick_label.modulate.a > 0.001:
		tick_label.modulate.a -= 5 * delta
	
	if see_light_batery:
		batery_label.visible = true
		batery_label.text = str(Global.linterna_bateria) + "%"


func _on_tick_timeout() -> void:
	if tick_count:
		tick_label.modulate.a = 1.0
	time_label.text = str(Global.time_hour) + ":" + str(Global.time_minute).pad_zeros(2)
	insanity_label.text = "Insanity: " + str(Global.insanity)
