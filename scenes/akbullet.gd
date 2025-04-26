extends Node3D

const SPEED = 40.0
@onready var ray: RayCast3D = $RayCast3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
