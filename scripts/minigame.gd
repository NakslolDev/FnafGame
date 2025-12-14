extends Node2D

@export var custom_pos := false

var transition_out := false
var trans_to_game: bool

var reading := false
var safing := false

@export var interact_nodes: Array[Node]
@export var custom_action: Node
@export var coliders_node: Node
@export var player: Node
@export var pop_text: Node
@export var pop_safe: Node

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Text"), 1.0)
	
	if not custom_pos:
		locate_char(Global.m_entering)
	
	connect_signals_recursively(coliders_node)
	
	if Global.m_entering == false:
		$Black_Foregraund.visible = false



func connect_signals_recursively(node: Node): #De esta forma conecta todo lo de dentro de coliders, aunque no sean hijos directos. Esto me permite organizar mejor
	for child in node.get_children():
		if child.has_signal("send_id_to_text"):
			child.connect("send_id_to_text", Callable(self, "_on_interacted_text"))
		if child.has_signal("do_action"):
			child.connect("do_action", Callable(self, "on_action"))
		
		# Llamada recursiva para nietos, bisnietos, etc.
		connect_signals_recursively(child)


func locate_char(entrance: bool):
	if entrance:
		player.position = Vector2(-512.0, 24.0)
	else:
		player.position = Vector2(-990.0, 840.0)

func _on_interacted_text(id: String, end_in: Array[int], read: int):
	if reading or safing:
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
	if reading or safing:
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

func on_action(action: String, read: int): # Aquí van las acciónes comunes
	
	if reading or safing:
		return
	
	if action == "Safe":
		safe()
	
	elif action == "Exit_pizza":
		if not transition_out:
			exit()
	
	elif action == "Begin_night":
		if not transition_out:
			begin()
	
	else:
		custom_action.do_custom_action(action, read) # Tengo un nodo a parte para las acciones custom, para organizar
	
	act_interact()
	act_active(coliders_node)

func act_interact():
	for _node in interact_nodes:
		if _node is Node2D and _node.has_method("act"):
			_node.act() # <- arreglar cuando el nodo no tiene la funcion o no tiene script directamente

func act_active(node: Node):
	
	for child in node.get_children():
		
		if child is Area2D:
			child.check_active()
		else:
			act_active(child)

func exit():
	player.freeze = true
	trans_to_game = false
	transition_out = true

func begin():
	player.freeze = true
	trans_to_game = true
	transition_out = true

func done_trans():
	Global.escena_previa = "Minigame"
	if trans_to_game:
		get_tree().change_scene_to_file("res://escenas/Main_Game.tscn")
	else:
		manage_end_night()

func manage_end_night():
	
	if Global.noche != 0 and Global.noche < 5:
		Global.noche += 1
		Global.guardar_partida()
	
	else:
		
		if Global.noche == 5:
			if Global.mapa["signed_in"]:
				Global.noche += 1
				Global.guardar_partida()
			
			else:
				get_tree().change_scene_to_file("res://escenas/endings/mediocre_ending.tscn")
				return
		
		elif Global.noche == 6:
			
			print("Invent:", Global.inventario)
			
			if Global.inventario["exe"]:
				get_tree().change_scene_to_file("res://escenas/endings/good_ending.tscn")
			elif Global.inventario["files"]:
				get_tree().change_scene_to_file("res://escenas/endings/bad_ending.tscn")
			else:
				get_tree().change_scene_to_file("res://escenas/endings/party_ending.tscn")
			return
	
	if not is_inside_tree():
		push_warning("manage_end_night(): el nodo ya no está en el árbol")
		return
	
	if Global.misc["When_win_go_to"] == "shift":
		Global.m_entering = true
		Global.minigame_starts()
		get_tree().change_scene_to_file("res://escenas/minigame.tscn")
	else:
		get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn")


func _input(event):
	if event.is_action_pressed("Esc"):
		$ESC_Timer.start()  # Empieza el conteo
	
	elif event.is_action_released("Esc"):
		$ESC_Timer.stop()  # Se cancela si suelta antes de tiempo

func _on_esc_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn")
