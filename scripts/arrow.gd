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
			if collider == null:
				return
			# Check for damageable interface via group
			if collider.is_in_group("enemy") or collider.is_in_group("spawner"):
				var target = collider
				# Climb to parent if needed
				while target and not target.has_method("hit"):
					target = target.get_parent()
				if target and target.has_method("hit"):
					target.hit(100.0)
			else: 
				queue_free()

func _on_timer_timeout() -> void:
	if !nocked: 
		queue_free()
