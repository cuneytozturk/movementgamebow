extends Node3D

const SPEED = 40.0
@onready var ray: RayCast3D = $RayCast3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit(20)
		queue_free()
