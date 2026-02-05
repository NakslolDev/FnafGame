extends Node

@export var custom_pos := false

var transitioning := false
var trans_to_game: bool

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

const posiciones_inicio := {
	"entrar": Vector2(-544.0, 29.0),
	"salir": Vector2(-995.0, 840.0),
	"bonnie": Vector2(-1057.0, 381.0), 
	"chica": Vector2(-953.0, 381.0),
	"freddy": Vector2(-1016.0, 381.0),
	"foxy": Vector2(-943.0, 656.0),
}

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Text"), 1.0)
	
	if Global.just_death_min == "none":
		player.freeze = true
	
	if not custom_pos:
		locate_char(Global.m_entering, Global.just_death_min)
	
	connect_signals_recursively(coliders_node)
	
	if Global.m_entering == false:
		camera.black_foreground.visible = false

func connect_signals_recursively(node: Node): #De esta forma conecta todo lo de dentro de coliders, aunque no sean hijos directos. Esto me permite organizar mejor
	for child in node.get_children():
		if child.has_signal("send_id_to_text"):
			child.connect("send_id_to_text", Callable(self, "_on_interacted_text"))
		if child.has_signal("do_action"):
			child.connect("do_action", Callable(self, "on_action"))
		
		# Llamada recursiva para nietos, bisnietos, etc.
		connect_signals_recursively(child)


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

func _on_intro_done() -> void:
	player.freeze = false
	transitioning = false

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

func on_action(action: String, read: int): # Aquí van las acciónes comunes
	
	if reading or safing or transitioning:
		return
	
	if action == "Safe":
		safe()
	
	elif action == "Exit_pizza":
		exit()
		begin_trans()
	
	elif action == "Begin_night":
		begin()
		begin_trans()
	
	else:
		custom_action.do_custom_action(action, read) # Tengo un nodo a parte para las acciones custom, para organizar
	
	act_interact()
	act_active(coliders_node)

func act_interact():
	for child in manual_act_nodes:
		if child.has_method("act"):
			child.act() # <- arreglar cuando el nodo no tiene la funcion o no tiene script directamente
		else:
			recursive_act_interact(child)

func recursive_act_interact(node: Node):
	for child in node.get_children():
		if child.has_method("act"):
			child.act() # <- arreglar cuando el nodo no tiene la funcion o no tiene script directamente
		else:
			recursive_act_interact(child)

func act_active(node: Node):
	
	for child in node.get_children():
		
		if child is Area2D:
			child.check_active()
		else:
			act_active(child)

func exit():
	player.freeze = true
	trans_to_game = false

func begin():
	player.freeze = true
	trans_to_game = true

func begin_trans():
	transicion.out()

func _on_transicion_done_out() -> void:
	Global.escena_previa = "Minigame"
	Global.just_death_min = "none" # Da igual lo que pase, que se ha de reiniciar
	if trans_to_game:
		Global.guardar_partida_provisional()
		get_tree().change_scene_to_file("res://escenas/Main_Game.tscn") #actualizar
	else:
		shiftCompleted.start_animation()

func _on_shift_completed_done() -> void:
	manage_end_night()

func manage_end_night():
	
	print("todo bien")
	if Global.inventario["exe"]:
		get_tree().change_scene_to_file("res://escenas/endings/good_ending.tscn") #actualizar # final bueno. Luego habra que cambiar la logica...
		return
	elif Global.inventario["files"]:
		get_tree().change_scene_to_file("res://escenas/endings/bad_ending.tscn") #actualizar # Final malo. La idea es que se active siempre que salgas, da igual en que noche estes
		return # El return es porque no tiene que hacer nada mas. Tampoco guardar partida. El progreso se guarda en otro lado
	
	elif Global.noche != 0 and Global.noche < 5: # Si es una noche normal, 1-4, suma 1 a la noche
		Global.noche += 1
	
	else: 
		
		if Global.noche == 5: # Noche 5
			if Global.mapa["signed_in"]:
				Global.noche += 1
			
			else:
				get_tree().change_scene_to_file("res://escenas/endings/mediocre_ending.tscn") #actualizar # Final mediocre
				return
		
		elif Global.noche == 6:
			get_tree().change_scene_to_file("res://escenas/endings/party_ending.tscn") #actualizar # Final de la noche 6. No tienes ni files ni exe
			return
	
	if not is_inside_tree():
		push_warning("manage_end_night(): el nodo ya no está en el árbol")
		return
	
	Global.guardar_partida() # guarda la partida.
	
	if Global.misc["When_win_go_to"] == "shift":
		Global.m_entering = true
		Global.minigame_starts()
		get_tree().change_scene_to_file("res://escenas/minigame.tscn") #actualizar
	else:
		get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn") #actualizar


func _input(event):
	if event.is_action_pressed("Esc"):
		$ESC_Timer.start()  # Empieza el conteo
	
	elif event.is_action_released("Esc"):
		$ESC_Timer.stop()  # Se cancela si suelta antes de tiempo

func _on_esc_timer_timeout() -> void:
	Global.escena_previa = "Minigame"
	Global.just_death_min = "none" # Da igual lo que pase, que se ha de reiniciar
	get_tree().change_scene_to_file("res://escenas/Menu_Principal.tscn") #actualizar
