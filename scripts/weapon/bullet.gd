extends Node3D

var damage
@onready var ray: RayCast3D = $RayCast3D
var velocity = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider && collider.is_in_group("enemy"):
			collider.hit(damage)
			Global.player.earncharge()
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
