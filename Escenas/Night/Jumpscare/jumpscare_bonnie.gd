extends Node2D

signal jumpscare_end

func _ready():
	$Bonnie.modulate.a = 0.0


func _on_main_game_jumpscare(who: String) -> void:
	if not who == "Bonnie":
		return
	$Bonnie.modulate.a = 1.0
	$"SmallFart-SoundEffect".play()
	$Jumpscare_duration.start()


func _on_jumpscare_duration_timeout() -> void:
	emit_signal("jumpscare_end")
