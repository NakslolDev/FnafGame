extends Node2D

@export var switch_on := true

@export_enum("General", "Ventilacion", "Puertas", "Linterna", "Camaras", "Heater", "Luces")
var controlador: String = "General"

signal Restaurar_General()

@export var tiny_click: AudioStreamPlayer
@export var sprite_on: Node2D
@export var sprite_off: Node2D
@export var office_behind: Node2D

const BREAKDOWN := true

func _ready():
	Global.Energy_Breakdown.connect(energia_out)
	switch_act(BREAKDOWN)

func switch_act(breakdown: bool = not BREAKDOWN):
	if not breakdown: tiny_click.play()

	sprite_on.visible = switch_on
	sprite_off.visible = !switch_on

	if breakdown and not controlador == "General":
		return

	if switch_on and controlador == "General":
		Restaurar_General.emit() # si se activa general, tengo que ver uno por uno cual se activa, eso lo controlo aqui. (La otra parte en Global)

	if not Global.energia["General"] and not controlador == "General":
		Global.set_energia(controlador, false)
	else:
		Global.set_energia(controlador, switch_on)

func energia_out():
	switch_on = false
	switch_act(BREAKDOWN)

func _on_click():
	if office_behind.stop_everything == true:
		return
	switch_on = !switch_on
	switch_act()


func _on_switch_general_restaurar_general() -> void:
	Global.set_energia(controlador, switch_on)
