extends Node3D
var pos
var rot
var nocked = true
var velocity

func _process(delta: float) -> void:
	if nocked:
		position = pos
		rotation = rot
	else:
		position += velocity * delta
