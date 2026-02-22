extends Node2D

@export var switch_on := true

@export_enum("General", "Ventilacion", "Puertas", "Linterna", "Camaras", "Heater", "Luces")
var controlador: String = "General"

signal Restaurar_General()

func _ready():
	Global.connect("Energy_Breakdown", Callable(self, "energia_out"))
	$Tiny_click.volume_linear = 0.0
	switch_act(switch_on)

func switch_act(value):
	$Tiny_click.play()
	if value:
		$SwitchOn.modulate.a = 1.0
		$SwitchOff.modulate.a = 0.0
	else:
		$SwitchOn.modulate.a = 0.0
		$SwitchOff.modulate.a = 1.0
	if value and (Global.energia["General"] or controlador == "General"):
		if controlador == "General":
			emit_signal("Restaurar_General")
		Global.set_energia(controlador, true)
	else:
		Global.set_energia(controlador, false)

func energia_out():
	if switch_on:
		_on_click()

func _on_click():
	if $"../..".stop_everything == true:
		return
	$Tiny_click.volume_linear = 1.0
	switch_on = !switch_on
	switch_act(switch_on)


func _on_switch_energia_1_restaurar_general() -> void:
	if switch_on:
		Global.set_energia(controlador, true)
	else:
		Global.set_energia(controlador, false)
