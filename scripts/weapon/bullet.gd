extends Node3D

var damage
var chargeearned
@onready var ray: RayCast3D = $RayCast3D
var velocity = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if ray.is_colliding():
		var collider = ray.get_collider()

		if collider && (collider.is_in_group("enemy") or collider.is_in_group("spawner")):
				var target = collider
				# Climb to parent if needed
				while target and not target.has_method("hit"):
					target = target.get_parent()
					Global.player.earncharge(chargeearned)
				if target and target.has_method("hit"):
					target.hit(damage)
					Global.player.earncharge(chargeearned)
				queue_free()


func _on_timer_timeout() -> void:
	queue_free()
