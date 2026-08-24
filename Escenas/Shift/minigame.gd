extends Node

@onready var scene_handler: Node = get_tree().get_first_node_in_group("scene_handler")

@export var custom_pos := false

var transitioning := false
var reading := false
var safing := false

@export var manual_act_nodes: Array[Node]
@export var custom_action: Node
@export var coliders_node: Node
@export var player: Node
@export var pop_text: Node
@export var pop_safe: Node
@export var transicion: Node
@export var shiftCompleted: Node
@export var camera: Node
@export var lights: Node2D

@export var spawn_points: Node
@onready var posiciones_inicio := { # si get child da problemas, usar find_child. No lo uso ya pues es más caro
	"entrar": spawn_points.get_child(0).position,
	"salir": spawn_points.get_child(1).position,
	"bonnie": spawn_points.get_child(2).position, 
	"chica": spawn_points.get_child(3).position,
	"freddy": spawn_points.get_child(4).position,
	"foxy": spawn_points.get_child(5).position,
}

signal act_sprites

func _enter_tree() -> void:
	add_to_group("minigame")

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Text"), 1.0)
	
	if Global.just_death_min == "none":
		player.freeze = true
	
	if not custom_pos:
		locate_char(Global.m_entering, Global.just_death_min)
	
	connect_signals_recursively(coliders_node)
	
	if Global.m_entering == false:
		#camera.black_foreground.visible = false
		lights.exiting()
	else:
		lights.entering()
	
	act_interact()

func connect_signals_recursively(node: Node): #De esta forma conecta todo lo de dentro de coliders, aunque no sean hijos directos. Esto me permite organizar mejor
	for child in node.get_children():
		if child.has_signal("send_id_to_text"):
			child.send_id_to_text.connect(_on_interacted_text)
		if child.has_signal("do_action"):
			child.do_action.connect(on_action)
		
		# Llamada recursiva para nietos, bisnietos, etc.
		connect_signals_recursively(child)

##char

func locate_char(entrance: bool, animatronic: String):
	if animatronic == "none":
		if entrance:
			player.position = posiciones_inicio["entrar"]
		else:
			player.position = posiciones_inicio["salir"]
	elif animatronic.ends_with("bonnie"): # tanto kbonnie como sbonnie van al mismo sitio. Lo mismo aplica para los demas
		player.position = posiciones_inicio["bonnie"]
	elif animatronic.ends_with("chica"):
		player.position = posiciones_inicio["chica"]
	elif animatronic.ends_with("freddy"):
		player.position = posiciones_inicio["freddy"]
	elif animatronic.ends_with("foxy"):
		player.position = posiciones_inicio["foxy"]
	camera.locate()


##interactables

func _on_interacted_text(id: String, end_in: Array[int], read: int):
	if reading or safing or transitioning:
		return
	reading = true
	pop_text.visible = true
	player.freeze = true
	pop_text.end_in = end_in
	pop_text.pop_up(id, read)

func _on_finished_text():
	reading = false
	pop_text.visible = false
	player.freeze = false

func safe():
	if reading or safing or transitioning:
		return
	safing = true
	pop_safe.visible = true
	pop_safe.pop_up()
	player.freeze = true

func _on_done_safing(not_automatic: bool, read: int, combination := []):
	safing = false
	pop_safe.visible = false
	player.freeze = false
	if Global.noche != 6:
		_on_interacted_text("Safe_too_soon", [], 0)
		return # evita cualquier cosa
	if not not_automatic != false: # llamo al texto manualmente, pues no es con un interact
		if combination == Global.safe_code:
			_on_interacted_text("Safe_know", [], 0)
			Global.mapa["safe_open"] = true
		else:
			_on_interacted_text("Safe_not_know", [1], read)
	else:
		_on_interacted_text("Safe_give_up", [1], read)
	act_interact() # Actualiza los nodos que controlan los coliders de forma manual
	act_active(coliders_node) # Actualiza recursivamente los propios coliders
	act_sprites.emit()

func on_action(action: String, read: int): # Aquí van las acciónes comunes
	
	if reading or safing or transitioning:
		return
	
	if action == "Safe":
		safe()
	
	elif action == "Exit_pizza":
		exit()
	
	elif action == "Begin_night":
		begin()
	
	else:
		custom_action.do_custom_action(action, read) # Tengo un nodo a parte para las acciones custom, para organizar
	
	act_interact()
	act_active(coliders_node)
	act_sprites.emit()

func act_interact():
	for child in manual_act_nodes:
		if child.has_method("act"):
			child.act() 
		else:
			recursive_act_interact(child)

func recursive_act_interact(node: Node):
	for child in node.get_children():
		if child.has_method("act"):
			child.act()
		else:
			recursive_act_interact(child)

func act_active(node: Node):
	
	for child in node.get_children():
		
		if child is Area2D:
			child.check_active()
		else:
			act_active(child)

##scene

func _on_intro_done() -> void:
	player.freeze = false
	transitioning = false

func exit():
	player.freeze = true
	transitioning = true
	scene_handler.trans_to_nothing()
	await scene_handler.done_fade_in
	shiftCompleted.start_animation()

func begin():
	player.freeze = true
	transitioning = true
	scene_handler.trans_to_scene(scene_handler.scene.NIGHT)


func _on_shift_completed_done() -> void:
	manage_end_shift()

const FORCE_EXIT := true
func _on_shift_completed_done_and_exit() -> void:
	manage_end_shift(FORCE_EXIT)

func manage_end_shift(force_exit := false):
	
	scene_handler.fleing = false # no devería ser problema, pero no molesta
	
	if Global.inventario["exe"]:
		scene_handler.ending = scene_handler.end.TRUE
		scene_handler.trans_to_scene(scene_handler.scene.END)

	elif Global.inventario["files"]:
		scene_handler.ending = scene_handler.end.BAD
		scene_handler.trans_to_scene(scene_handler.scene.END)

	elif Global.noche == 6:
		scene_handler.ending = scene_handler.end.PARTY
		scene_handler.trans_to_scene(scene_handler.scene.END)

	elif Global.noche == 5 and not Global.mapa["signed_in"]:
		scene_handler.ending = scene_handler.end.MEDIOCRE
		scene_handler.trans_to_scene(scene_handler.scene.END)

	else:
		if Global.misc["When_win_go_to"] == "shift" and not force_exit:
			scene_handler.trans_to_scene(scene_handler.scene.SHIFT)
		else:
			scene_handler.trans_to_scene(scene_handler.scene.MAIN_MENU)

@export var esc_timer: Timer
func _input(event):
	if transitioning:
		return
	
	if event.is_action_pressed("Esc"):
		esc_timer.start()  # Empieza el conteo
	
	elif event.is_action_released("Esc"):
		esc_timer.stop()  # Se cancela si suelta antes de tiempo

const QUICK_TRANSITION_TIME := 0.5
func _on_esc_timer_timeout() -> void:
	player.freeze = true
	scene_handler.fleing = true
	scene_handler.trans_to_scene(scene_handler.scene.MAIN_MENU, QUICK_TRANSITION_TIME)
