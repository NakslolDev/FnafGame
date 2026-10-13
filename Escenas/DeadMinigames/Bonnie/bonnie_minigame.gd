extends Node

enum Candy {NONE, RED, ORANGE, BLUE, YELLOW}
enum Pow {NONE, SPEED, JUMP, MAGNET, MORE}

var combo: Candy
var power: Pow

@export var candy: Sprite2D
@export var pw: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combo = Candy.NONE
	power = Pow.NONE
	
	set_candy()
	set_pow()


func set_candy():
	candy.visible = combo != Candy.NONE
	if candy.visible:
		candy.frame = combo - 1

func set_pow():
	pw.visible = power != Pow.NONE
	if pw.visible:
		pw.frame = combo - 1
