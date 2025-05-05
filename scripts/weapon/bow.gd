extends BaseWeapon
@onready var anim: AnimationPlayer = $AnimationPlayer
var arrow_scene: PackedScene
var arrow
@export var bullet_speed = 69


@onready var string: Node3D = $string

func _process(delta: float) -> void:
	if arrow:
		arrow.pos = string.global_position
		arrow.rot = string.global_rotation
	
func start_fire():
	arrow_scene = load("res://scenes/arrow.tscn")
	arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(arrow)
	arrow.nocked = true
	anim.play("draw")
func stop_fire():
	anim.play("release")
	shoot_arrow()
func start_alt_fire():
	pass
func stop_alt_fire():
	pass
	
func shoot_arrow():
	arrow.nocked = false
	arrow.velocity = string.global_transform.basis.z * bullet_speed

	print("arrpw")
