extends Node2D

var _local_girando: int # 1 derecha. 2 izquierda. - volviendo. 0 quieto

func _on_oficina_girando_estado(girando: int) -> void:
	_local_girando = girando
