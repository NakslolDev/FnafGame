extends Node2D

signal Puerta_Cambio(puerta_activada: bool)
signal ButtonPlay(on: bool)

@export var root: Node2D

@export var verde: Node2D
@export var rojo: Node2D
@export var no_energia: Node2D

@export var boton_izquierda := true
var puerta_activada := false
var mouse_entered := false
var local_girando: int

var stuck_door := false

const NO_AUDIO := false

func _ready():
	actualizar_sprites(NO_AUDIO)
	Global.energia_actualizada.connect(energia_act)

func energia_act():
	actualizar_sprites(NO_AUDIO)
	stuck_door = false
	if puerta_activada and not Global.energia["Puertas"]:
		puerta_activada = false
		Puerta_Cambio.emit(puerta_activada)

func _on_click():
	if root.camaras_activadas or root.tick_stop:
		return
	if not Global.energia["Puertas"]:
		return
	
	puerta_activada = !puerta_activada
	actualizar_sprites()
	if not stuck_door: Puerta_Cambio.emit(puerta_activada)
	if not puerta_activada and randi_range(0,50) == 0 and Global.noche != 1 and Global.noche != 2 and Global.noche != 3: # no quiero que suceda en las primeras noches, pues tengo intención de        
		stuck_door = true # decir en la primera noche que las puertas se pueden atascar, pero que no suceda hasta la noche 4...


func _input(event):
	if boton_izquierda:
		if local_girando == 3 and Global.misc["Switch_Doors_Back"]:
			if event.is_action_pressed("Puerta_Derecha"):
				_on_click()
		else:
			if event.is_action_pressed("Puerta_Izquierda"):
				_on_click()
	
	else:
		if local_girando == 3 and Global.misc["Switch_Doors_Back"]:
			if event.is_action_pressed("Puerta_Izquierda"):
				_on_click()
		else:
			if event.is_action_pressed("Puerta_Derecha"):
				_on_click()

func actualizar_sprites(audio := true):
	if Global.energia["General"] and Global.energia["Puertas"]:
		no_energia.visible = false
		if puerta_activada:
			rojo.visible = false
			verde.visible = true
			if audio: ButtonPlay.emit(true)
		else:
			rojo.visible = true
			verde.visible = false
			if audio: ButtonPlay.emit(false)
	else:
		no_energia.visible = true

func _on_oficina_girando_estado(girando: int) -> void:
	local_girando = girando
