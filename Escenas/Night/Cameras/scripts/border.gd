extends Sprite2D

@export var dot: Sprite2D
@export var dot_timer: Timer

@export var batery_1: Sprite2D
@export var batery_2: Sprite2D
@export var batery_3: Sprite2D

var _energia: int
var energia: int:
	get = get_energia, set = set_energia

func get_energia():
	return _energia

func set_energia(value: int):
	_energia = value
	batery_1.visible = value >= 1
	batery_2.visible = value >= 2
	batery_3.visible = value >= 3

func _ready():
	dot_timer.start()

func _process(_delta):
	if energia != Global.energia_consumption["Total"]:
		energia = Global.energia_consumption["Total"]

func _on_timer_timeout() -> void:
	if Global.energia["Camaras"] == false:
		dot.visible = false
	elif dot.visible == false:
		dot.visible = true
	else:
		dot.visible = false
