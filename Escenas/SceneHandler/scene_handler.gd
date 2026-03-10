extends Node

signal done_fade_in
signal done_fade_out

var changing_scene: bool = false

enum scene {NULL, NIGHT, SHIFT, DEATH_MINIGAME, MAIN_MENU, CUSTOM_NIGHT, OPTIONS, DEATH, SIX_AM, END}
var current_scene: scene = scene.NULL
var last_scene: scene = scene.NULL

@export var transition: Sprite2D

@export_category("Scenes")

@export var main_game: PackedScene
@export var minigame: PackedScene
@export var death_minigame_loader: PackedScene
@export var menu_principal: PackedScene
@export var opciones: PackedScene
@export var custom_night_selecter: PackedScene
@export var dead_scene: PackedScene
@export var ending_screen: PackedScene
@export var _6_am: PackedScene


var current_tree_scene: Node

##general

func _enter_tree() -> void:
	add_to_group("scene_handler")

func _ready():
	
	Global.eliminar_debug_partida() # De existir, elimina el archivo
	
	Global.guardar_configuration_default()
	
	Global.leer_configuration()
	Global.leer_progreso()
	Global.leer_partida()
	
	change_to_main_menu()
	
	Global.aply_screen_configuration()

func _act_current_scene(new: scene):
	last_scene = current_scene
	current_scene = new
	print("")
	print("scene changed: ", scene.keys()[last_scene], " -> ", scene.keys()[current_scene])
	print("")

func trans_to_scene(next: scene, fade_time: float = transition.DEFAULT_TRANSITION_TIME):
	
	if changing_scene:
		return
	changing_scene = true
	
	transition.fade_in(fade_time)
	await transition.done_fade_in
	match next:
		scene.MAIN_MENU:
			change_to_main_menu(true)
		scene.OPTIONS:
			change_to_options(true)
		scene.CUSTOM_NIGHT:
			change_to_custom_night(true)
		scene.NIGHT:
			change_to_main_game(true)
		scene.SHIFT:
			change_to_shift(true)
		scene.DEATH_MINIGAME:
			change_to_death_minigame(true)
		scene.DEATH:
			change_to_death_scene(true)
		scene.SIX_AM:
			change_to_6_am(true)
		scene.END:
			change_to_ending(true)
		scene.NULL:
			pass

func trans_to_nothing(fade_time: float = transition.DEFAULT_TRANSITION_TIME, hold_time: float = 1.0):
	transition.fade_in(fade_time)
	await transition.done_fade_in
	done_fade_in.emit()
	await get_tree().create_timer(hold_time).timeout
	transition.fade_out(fade_time)
	await  transition.done_fade_out
	done_fade_out.emit()

func _manage_exit_scenes(new: scene): # aquí va la lógica al salir de una escena, no al entrar a esta
	match current_scene:
		scene.SHIFT:
			_manage_exit_minigame(new)

##main changers

func change_to_main_menu(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.MAIN_MENU)
	_manage_main_menu_before_change()
	_act_current_scene(scene.MAIN_MENU)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = menu_principal.instantiate()
	add_child(current_tree_scene)
	_manage_main_menu()
	changing_scene = false

func change_to_options(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.OPTIONS)
	_act_current_scene(scene.OPTIONS)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = opciones.instantiate()
	add_child(current_tree_scene)
	changing_scene = false

func change_to_custom_night(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.CUSTOM_NIGHT)
	_act_current_scene(scene.CUSTOM_NIGHT)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = custom_night_selecter.instantiate()
	add_child(current_tree_scene)
	_manage_custom_night()
	changing_scene = false

func change_to_main_game(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.NIGHT)
	_manage_night_before_change()
	_act_current_scene(scene.NIGHT)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = main_game.instantiate()
	add_child(current_tree_scene)
	_manage_night()
	changing_scene = false

func change_to_shift(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.SHIFT)
	_manage_minigame_before_change()
	_act_current_scene(scene.SHIFT)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = minigame.instantiate()
	add_child(current_tree_scene)
	_manage_minigame()
	changing_scene = false

func change_to_death_minigame(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.DEATH_MINIGAME)
	_act_current_scene(scene.DEATH_MINIGAME)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = death_minigame_loader.instantiate()
	add_child(current_tree_scene)
	changing_scene = false

func change_to_death_scene(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.DEATH)
	_act_current_scene(scene.DEATH)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = dead_scene.instantiate()
	add_child(current_tree_scene)
	changing_scene = false

func change_to_6_am(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.SIX_AM)
	_act_current_scene(scene.SIX_AM)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = _6_am.instantiate()
	add_child(current_tree_scene)
	_manage_6_am()
	changing_scene = false

enum end {MEDIOCRE, PARTY, BAD, TRUE, SECRET} # el secret puede quedar sin uso, dependiendo de si le doy una patalla o no. De momento se puede quitar 
var ending: end # estas variables se les da valor en las escenas

func change_to_ending(force: bool = false):
	if changing_scene and not force: return
	changing_scene = true
	_manage_exit_scenes(scene.END)
	_act_current_scene(scene.END)
	if current_tree_scene != null: current_tree_scene.queue_free()
	await get_tree().process_frame
	current_tree_scene = ending_screen.instantiate()
	add_child(current_tree_scene)
	_manage_endign_screen()
	changing_scene = false

##managers

func _manage_main_menu_before_change():
	Global.leer_partida()

func _manage_main_menu():
	if last_scene == scene.NULL:
		transition.instant_fade_in()
	transition.fade_out()
	
	Global.eliminar_partida_provisional()
	if not Global.debug["debug_mode"]:
		Global.eliminar_debug_partida()

func _manage_custom_night():
	transition.fade_out()


func _manage_minigame_before_change():
	if current_scene in [scene.MAIN_MENU, scene.SHIFT, scene.DEATH, scene.DEATH_MINIGAME]:
		Global.m_entering = true
	elif current_scene in [scene.SIX_AM]:
		Global.m_entering = false
	
	if current_scene == scene.DEATH_MINIGAME:
		Global.guardar_death_minigames()
	else:
		if Global.m_entering:
			Global.leer_partida() # En esta funcion es donde se maneja el debug
			Items.reset()
		else:
			Global.eliminar_partida_provisional()
	
	Global.minigame_starts()

func _manage_minigame():
	if Global.m_entering:
		transition.instant_fade_out()
	else:
		transition.fade_out()
		await get_tree().create_timer(1.0).timeout
		current_tree_scene._on_intro_done() # simplemente desbloquea al jugador
	Global.custom_night_ai = [0,0,0,0] # Lo reseteo en minigame para que solo se resetee si juegas normalmente

var fleing := false
func _manage_exit_minigame(new: scene):
	Global.just_death_min = "none" # Da igual lo que pase, que se ha de reiniciar
	
	if fleing: # sales con esc...
		fleing = false
		return

	if not new in [scene.NIGHT, scene.END]:
		Global.noche += 1
		Global.randomice_map_items() # importante llamar a esto antes de guardar partida, pues la idea es que no puedes salir y volver a entrar para tener otra loot table
		# Además, es a posta que solamente aparezcan en la segunda noche... Aunque igual lo cambio (añadir la función a Global.create_new_game)
		Global.guardar_partida()


func _manage_night_before_change():
	if current_scene == scene.SHIFT:
		Global.guardar_partida_provisional()
	elif current_scene == scene.CUSTOM_NIGHT:
		Global.noche = 0
		Global.location_key = 0
	
	Global.leer_partida_provisional()
	Global.reset_night()

func _manage_night():
	transition.instant_fade_out()


func _manage_6_am():
	if Global.noche == 0 and Global.custom_night_ai == [20, 20, 20, 20]:
		Global.finales["420"] = true
		Global.guardar_progreso()


const MEDIOCRE_FUNC := "show_mediocre"
const PARTY_FUNC := "show_party"
const BAD_FUNC := "show_bad"
const TRUE_FUNC := "show_true"

func _manage_endign_screen():
	match ending:
		end.MEDIOCRE:
			if current_tree_scene.has_method(MEDIOCRE_FUNC): current_tree_scene.call(MEDIOCRE_FUNC)
			Global.finales["mediocre"] = true
		end.PARTY:
			if current_tree_scene.has_method(PARTY_FUNC): current_tree_scene.call(PARTY_FUNC)
			Global.finales["party"] = true
		end.BAD:
			if current_tree_scene.has_method(BAD_FUNC): current_tree_scene.call(BAD_FUNC)
			Global.finales["bad"] = true
		end.TRUE:
			if current_tree_scene.has_method(TRUE_FUNC): current_tree_scene.call(TRUE_FUNC)
			Global.finales["true"] = true
	
	Global.custom_night = true
	Global.guardar_progreso()
	
	transition.fade_out()

##other

func reset_options_scene():
	current_tree_scene.queue_free()
	current_tree_scene = opciones.instantiate()
	add_child(current_tree_scene)


const COOL_TRANS_FADE_TIME := 8.0
func cool_6_am_transition():
	
	if changing_scene: return
	changing_scene = true
	
	if current_scene != scene.NIGHT:
		push_error("tf you doing, cool 6am transition is for night only")
	
	var new_node: Node = _6_am.instantiate()
	new_node.everything.modulate.a = 0.0
	current_tree_scene.add_sibling(new_node)
	
	current_tree_scene.tick_stop = true
	current_tree_scene.on_tick_stop.emit()
	
	new_node.can_exit = false
	 
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(
		new_node.everything, "modulate:a", 1.0, COOL_TRANS_FADE_TIME
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	
	new_node.can_exit = true
	_act_current_scene(scene.SIX_AM)
	
	if current_tree_scene != null: current_tree_scene.queue_free()
	current_tree_scene = new_node
	
	_manage_6_am()
	changing_scene = false
