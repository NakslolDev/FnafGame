extends Node2D

@export var switch_on := true

@export_enum("General", "Ventilacion", "Puertas", "Linterna", "Camaras", "Heater", "Luces")
var controlador: String = "General"

signal Restaurar_General()

@export var tiny_click: AudioStreamPlayer
@export var switch_off: Sprite2D
@export var switch_on_sprite: Sprite2D
@export var office_behind: Node2D

const SILENT := true

func _ready():
	Global.Energy_Breakdown.connect(energia_out)

func switch_act(value, silent: bool = not SILENT):
	if not silent: tiny_click.play()
	
	switch_on_sprite.visible = value
	switch_off.visible = !value
	
	if value and (Global.energia["General"] or controlador == "General"):
		if controlador == "General":
			Restaurar_General.emit()
	Global.set_energia(controlador, value)

func energia_out():
	switch_on = false
	switch_act(switch_on, SILENT)

func _on_click():
	if office_behind.stop_everything == true:
		return
	switch_on = !switch_on
	switch_act(switch_on)


func _on_switch_energia_1_restaurar_general() -> void:
	if switch_on:
		Global.set_energia(controlador, true)
	else:
		Global.set_energia(controlador, false)
