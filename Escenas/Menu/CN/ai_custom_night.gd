extends VBoxContainer

@export var who: int
var focus_mas: bool
@onready var AI_level: int = Global.custom_night_ai[who]

func _ready():
	act_ai()

func act_ai():
	$HBoxContainer/Nivel_AI.text = str(AI_level)
	Global.custom_night_ai[who] = AI_level


func _on_menos_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if AI_level > 0:
			focus_mas = false
			$Timer.start(0.3)
			AI_level -= 1
			act_ai()

func _on_mas_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if AI_level < 20:
			focus_mas = true
			$Timer.start(0.3)
			AI_level += 1
			act_ai()

func _on_timer_timeout() -> void:
	if Input.is_action_pressed("Click"):
		if focus_mas:
			if AI_level < 20:
				AI_level += 1
		else:
			if AI_level > 0:
				AI_level -= 1
		act_ai()
		$Timer.start(0.05)
