extends Node3D

const DAMAGE = 20.0
@onready var ray: RayCast3D = $RayCast3D
var velocity = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if ray.is_colliding():
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit(DAMAGE)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
