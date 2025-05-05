extends BaseWeapon
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var marker_3d: MeshInstance3D = $ball
@onready var string: Node3D = $string

var arrow_scene: PackedScene
var arrow

@export var bow_shake := 0.0
@export var bullet_speed = 69

func _process(delta: float) -> void:
	var ray = Global.player.middlepoint  # Your RayCast3D node
	if marker_3d && ray.is_colliding():
		marker_3d.global_position = ray.get_collision_point()
		marker_3d.visible = true
	else:
		marker_3d.visible = false
		
	if arrow:
		arrow.pos = string.global_position
		arrow.rot = string.global_rotation
	
func start_fire():
	arrow_scene = load("res://scenes/arrow.tscn")
	arrow = arrow_scene.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.nocked = true
	anim.play("bow/draw")

func stop_fire():
	anim.play("bow/release")
	shoot_arrow()
	Global.player.shakeable_camera.add_trauma(bow_shake)

	
func shoot_arrow():
	if arrow:
		arrow.nocked = false
		var ray = Global.player.middlepoint
		if ray.is_colliding():
			arrow.look_at(ray.get_collision_point(), Vector3.UP)
		else:
			arrow.look_at(Global.player.misspoint.global_position, Vector3.UP)
		arrow.velocity = -arrow.global_transform.basis.z * bullet_speed
