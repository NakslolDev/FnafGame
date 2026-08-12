extends Sprite2D

var flicker_on := false
var mouse_on := 0
signal cam_act

@export var camaras: Node2D
@export var flicker_timer: Timer
@export var _1: Sprite2D
@export var _2: Sprite2D
@export var _3: Sprite2D
@export var _4: Sprite2D
@export var _5: Sprite2D
@export var _6: Sprite2D
@export var _7: Sprite2D
@export var _8: Sprite2D
@export var _9: Sprite2D
@export var _10a: Sprite2D
@export var _10b: Sprite2D
@export var _11a: Sprite2D
@export var _11b: Sprite2D

func _ready():
	flicker_on = true
	flicker_timer.start()
	act_buttons()

func _input(event: InputEvent) -> void:
	if not camaras.activado:
		return
	
	if event.is_action_pressed("Puerta_Derecha"):
		cambiar_cam_teclas(false, false, false, true)
	if event.is_action_pressed("Puerta_Izquierda"):
		cambiar_cam_teclas(false, true, false, false)
	if event.is_action_pressed("Girarse"):
		cambiar_cam_teclas(false, false, true, false)
	if event.is_action_pressed("CamUpSelect"):
		cambiar_cam_teclas(true, false, false, false)

func cambiar_cam_teclas(w: bool, a: bool, s: bool, d: bool):
	var camara_activa = camaras.camara_activa
	
	if camara_activa == 1:
		if w:
			activate_cam_2()
		elif a:
			activate_cam_9()
		elif s:
			activate_cam_13()
		elif d:
			activate_cam_3()
	elif camara_activa == 2:
		if w:
			pass
		elif a:
			activate_cam_7()
		elif s:
			activate_cam_9() # no se si cam 9 o cam 1
		elif d:
			activate_cam_4()
	elif camara_activa == 3:
		if w:
			activate_cam_4()
		elif a:
			activate_cam_1()
		elif s:
			activate_cam_12()
		elif d:
			activate_cam_5()
	elif camara_activa == 4:
		if w:
			pass
		elif a:
			activate_cam_2()
		elif s:
			activate_cam_3()
		elif d:
			pass
	elif camara_activa == 5:
		if w:
			activate_cam_3()
		elif a:
			activate_cam_12()
		elif s:
			activate_cam_6()
		elif d:
			pass
	elif camara_activa == 6:
		if w:
			activate_cam_5()
		elif a:
			activate_cam_12()
		elif s:
			pass
		elif d:
			pass
	elif camara_activa == 7:
		if w:
			activate_cam_2()
		elif a:
			pass
		elif s:
			activate_cam_8()
		elif d:
			activate_cam_10()
	elif camara_activa == 8:
		if w:
			activate_cam_7()
		elif a:
			pass
		elif s:
			pass
		elif d:
			activate_cam_11() # aqui no se si poner cam 10 o cam 11
	elif camara_activa == 9:
		if w:
			activate_cam_2()
		elif a:
			activate_cam_10()
		elif s:
			activate_cam_11()
		elif d:
			activate_cam_1()
	elif camara_activa == 10:
		if w:
			activate_cam_9()
		elif a:
			activate_cam_7()
		elif s:
			activate_cam_8()
		elif d:
			activate_cam_11()
	elif camara_activa == 11:
		if w:
			activate_cam_9()
		elif a:
			activate_cam_10()
		elif s:
			activate_cam_8()
		elif d:
			activate_cam_13()
	elif camara_activa == 12:
		if w:
			activate_cam_3() # no se si cam 3 o cam 1
		elif a:
			activate_cam_13()
		elif s:
			activate_cam_6()
		elif d:
			activate_cam_5()
	elif camara_activa == 13:
		if w:
			activate_cam_1() # no se si cam 1 o cam 9
		elif a:
			activate_cam_11()
		elif s:
			activate_cam_6()
		elif d:
			activate_cam_12()
	
	flicker_on = true
	flicker_timer.start()
	act_buttons()

func act_buttons():
	Bonnie.camara = camaras.camara_activa
	Chica.camara = camaras.camara_activa
	Freddy.camara = camaras.camara_activa
	if get_node_or_null(".") == null:
		return
	_1.visible = false
	_2.visible = false
	_3.visible = false
	_4.visible = false
	_5.visible = false
	_6.visible = false
	_7.visible = false
	_8.visible = false
	_9.visible = false
	_10a.visible = false
	_10b.visible = false
	_11a.visible = false
	_11b.visible = false
	if (camaras.camara_activa == 1 and flicker_on) or mouse_on == 1:
		_1.visible = true
	if (camaras.camara_activa == 2 and flicker_on) or mouse_on == 2:
		_2.visible = true
	if (camaras.camara_activa == 3 and flicker_on) or mouse_on == 3:
		_3.visible = true
	if (camaras.camara_activa == 4 and flicker_on) or mouse_on == 4:
		_4.visible = true
	if (camaras.camara_activa == 5 and flicker_on) or mouse_on == 5:
		_5.visible = true
	if (camaras.camara_activa == 6 and flicker_on) or mouse_on == 6:
		_6.visible = true
	if (camaras.camara_activa == 7 and flicker_on) or mouse_on == 7:
		_7.visible = true
	if (camaras.camara_activa == 8 and flicker_on) or mouse_on == 8:
		_8.visible = true
	if (camaras.camara_activa == 9 and flicker_on) or mouse_on == 9:
		_9.visible = true
	if (camaras.camara_activa == 10 and flicker_on) or mouse_on == 10:
		_10a.visible = true
	if (camaras.camara_activa == 11 and flicker_on) or mouse_on == 11:
		_10b.visible = true
	if (camaras.camara_activa == 12 and flicker_on) or mouse_on == 12:
		_11a.visible = true
	if (camaras.camara_activa == 13 and flicker_on) or mouse_on == 13:
		_11b.visible = true

func _on_flicker_timer_timeout() -> void:
	flicker_on = !flicker_on
	act_buttons()


func activate_cam_1():
	camaras.camara_activa = 1
	cam_act.emit()
	act_buttons()

func _on_area_1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_1()

func _on_area_1_mouse_entered() -> void:
	mouse_on = 1
	
	act_buttons()

func _on_area_1_mouse_exited() -> void:
	if mouse_on == 1:
		mouse_on = 0
		
	if camaras.camara_activa == 1:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_2():
	camaras.camara_activa = 2
	cam_act.emit()
	act_buttons()

func _on_area_2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_2()

func _on_area_2_mouse_entered() -> void:
	mouse_on = 2
	
	act_buttons()

func _on_area_2_mouse_exited() -> void:
	if mouse_on == 2:
		mouse_on = 0
		
	if camaras.camara_activa == 2:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_3():
	camaras.camara_activa = 3
	cam_act.emit()
	act_buttons()

func _on_area_3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_3()

func _on_area_3_mouse_entered() -> void:
	mouse_on = 3
	
	act_buttons()

func _on_area_3_mouse_exited() -> void:
	if mouse_on == 3:
		mouse_on = 0
		
	if camaras.camara_activa == 3:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_4():
	camaras.camara_activa = 4
	cam_act.emit()
	act_buttons()

func _on_area_4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_4()

func _on_area_4_mouse_entered() -> void:
	mouse_on = 4
	
	act_buttons()

func _on_area_4_mouse_exited() -> void:
	if mouse_on == 4:
		mouse_on = 0
		
	if camaras.camara_activa == 4:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_5():
	camaras.camara_activa = 5
	cam_act.emit()
	act_buttons()

func _on_area_5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_5()

func _on_area_5_mouse_entered() -> void:
	mouse_on = 5
	
	act_buttons()

func _on_area_5_mouse_exited() -> void:
	if mouse_on == 5:
		mouse_on = 0
		
	if camaras.camara_activa == 5:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_6():
	camaras.camara_activa = 6
	cam_act.emit()
	act_buttons()

func _on_area_6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_6()

func _on_area_6_mouse_entered() -> void:
	mouse_on = 6
	
	act_buttons()

func _on_area_6_mouse_exited() -> void:
	if mouse_on == 6:
		mouse_on = 0
		
	if camaras.camara_activa == 6:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_7():
	camaras.camara_activa = 7
	cam_act.emit()
	act_buttons()

func _on_area_7_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_7()

func _on_area_7_mouse_entered() -> void:
	mouse_on = 7
	
	act_buttons()

func _on_area_7_mouse_exited() -> void:
	if mouse_on == 7:
		mouse_on = 0
		
	if camaras.camara_activa == 7:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_8():
	camaras.camara_activa = 8
	cam_act.emit()
	act_buttons()

func _on_area_8_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_8()

func _on_area_8_mouse_entered() -> void:
	mouse_on = 8
	
	act_buttons()

func _on_area_8_mouse_exited() -> void:
	if mouse_on == 8:
		mouse_on = 0
		
	if camaras.camara_activa == 8:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_9():
	camaras.camara_activa = 9
	cam_act.emit()
	act_buttons()

func _on_area_9_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_9()

func _on_area_9_mouse_entered() -> void:
	mouse_on = 9
	
	act_buttons()

func _on_area_9_mouse_exited() -> void:
	if mouse_on == 9:
		mouse_on = 0
		
	if camaras.camara_activa == 9:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_10():
	camaras.camara_activa = 10
	cam_act.emit()
	act_buttons()

func _on_area_10_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_10()

func _on_area_10_mouse_entered() -> void:
	mouse_on = 10
	
	act_buttons()

func _on_area_10_mouse_exited() -> void:
	if mouse_on == 10:
		mouse_on = 0
		
	if camaras.camara_activa == 10:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_11():
	camaras.camara_activa = 11
	cam_act.emit()
	act_buttons()

func _on_area_11_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_11()

func _on_area_11_mouse_entered() -> void:
	mouse_on = 11
	
	act_buttons()

func _on_area_11_mouse_exited() -> void:
	if mouse_on == 11:
		mouse_on = 0
		
	if camaras.camara_activa == 11:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_12():
	camaras.camara_activa = 12
	cam_act.emit()
	act_buttons()

func _on_area_12_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_12()

func _on_area_12_mouse_entered() -> void:
	mouse_on = 12
	
	act_buttons()

func _on_area_12_mouse_exited() -> void:
	if mouse_on == 12:
		mouse_on = 0
		
	if camaras.camara_activa == 12:
		flicker_on = true
		flicker_timer.start()
	act_buttons()


func activate_cam_13():
	camaras.camara_activa = 13
	cam_act.emit()
	act_buttons()

func _on_area_13_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if camaras.ductos == false and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activate_cam_13()

func _on_area_13_mouse_entered() -> void:
	mouse_on = 13
	
	act_buttons()

func _on_area_13_mouse_exited() -> void:
	if mouse_on == 13:
		mouse_on = 0
		
	if camaras.camara_activa == 13:
		flicker_on = true
		flicker_timer.start()
	act_buttons()
