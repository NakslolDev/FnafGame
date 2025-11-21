extends Sprite2D

var _energia: int
var energia: int:
	get = get_energia, set = set_energia

func get_energia():
	return _energia

func set_energia(value: int):
	_energia = value
	if value == 0:
		$BateryBase/Batery1.modulate.a = 0.0
		$BateryBase/Batery2.modulate.a = 0.0
		$BateryBase/Batery3.modulate.a = 0.0
	elif value == 1:
		$BateryBase/Batery1.modulate.a = 1.0
		$BateryBase/Batery2.modulate.a = 0.0
		$BateryBase/Batery3.modulate.a = 0.0
	elif value == 2:
		$BateryBase/Batery1.modulate.a = 1.0
		$BateryBase/Batery2.modulate.a = 1.0
		$BateryBase/Batery3.modulate.a = 0.0
	else:
		$BateryBase/Batery1.modulate.a = 1.0
		$BateryBase/Batery2.modulate.a = 1.0
		$BateryBase/Batery3.modulate.a = 1.0

func _ready():
	$Dot/Timer.start()

func _process(_delta):
	if energia != Global.energia_consumption["Total"]:
		energia = Global.energia_consumption["Total"]

func _on_timer_timeout() -> void:
	if Global.energia["Camaras"] == false:
		$Dot.modulate.a = 0.0
	elif $Dot.modulate.a == 0.0:
		$Dot.modulate.a = 1.0
	else:
		$Dot.modulate.a = 0.0
