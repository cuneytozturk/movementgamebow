extends Node3D
var pos
var rot
var nocked = true
var velocity
@onready var ray: RayCast3D = $ray
var p = Global.player

func _process(delta: float) -> void:
	if nocked:
		position = pos
		rotation = rot
		pass
	else:
		position += velocity * delta
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider && collider.is_in_group("enemy"):
				collider.hit(100.0)
			queue_free()

func _on_timer_timeout() -> void:
	if !nocked: 
		queue_free()
