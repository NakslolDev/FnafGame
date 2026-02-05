extends Node2D

func _ready():
	$Gyro01.visible = true
	$Gyro02.visible = false
	$Gyro03.visible = false


func _on_timer_timeout() -> void:
	if $Gyro01.visible:
		$Gyro01.visible = false
		$Gyro02.visible = true
	elif $Gyro02.visible:
		$Gyro02.visible = false
		$Gyro03.visible = true
	elif $Gyro03.visible:
		$Gyro03.visible = false
		$Gyro01.visible = true
