extends BaseWeapon
@onready var muzzle: Node3D = $muzzle
var bullet_scene : PackedScene

var firing = false
var can_fire = true

@export var bullet_speed = 30
@export var max_angle_degrees = 60.0
@export var spread = 0.01



func _ready():
	bullet_scene = load("res://scenes/bullet.tscn")

func _physics_process(delta: float) -> void:
	if firing && can_fire:
		shoot()

func shoot():
	spawnBullet()
	can_fire = false
	await get_tree().create_timer(1.0 / fire_rate).timeout
	can_fire = true

func start_fire():
	firing = true

func stop_fire():
	firing = false

func spawnBullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
	
	# tilt bullets
	bullet.rotate_object_local(Vector3.FORWARD, deg_to_rad(randf_range(-max_angle_degrees, max_angle_degrees)))
	
	var random_spread = Vector3(
		randf_range(-spread, spread),
		randf_range(-spread, spread),
		0
	)
	
	bullet.velocity = (-muzzle.global_transform.basis.z + random_spread).normalized() * bullet_speed
	get_tree().current_scene.add_child(bullet)
