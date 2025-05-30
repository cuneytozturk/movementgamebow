extends BaseWeapon
@onready var muzzle: Node3D = $muzzle
var bullet_scene : PackedScene
@onready var ray: RayCast3D = $RayCast3D
var bullet_trail : PackedScene
@onready var ray_end: Node3D = $ray_end
@onready var beam: Area3D = $beam
@onready var beam_coll: CollisionShape3D = $beam/beam_coll




@export var bullet_speed = 30
@export var bullet_damage = 30
@export var max_angle_degrees = 60.0
@export var spread = 0.01
@export var alt_fire_rate: float


func _ready():
	bullet_scene = load("res://scenes/bullet.tscn")
	bullet_trail = load("res://scenes/laser_trail.tscn")
func _physics_process(delta: float) -> void:
	if firing && can_fire:
		shoot()
	if altfiring && can_alt_fire:
		altshoot()

func shoot():
	spawnBullet()
	can_fire = false
	await get_tree().create_timer(1.0 / fire_rate).timeout
	can_fire = true

func altshoot():
	if Global.player.charge >= 100:
		spawnHitscanBullet()
		Global.player.charge -= 100
		can_alt_fire = false
		await get_tree().create_timer(1.0 / alt_fire_rate).timeout
		can_alt_fire = true
		

func start_fire():
	firing = true

func stop_fire():
	firing = false

func start_alt_fire():
	altfiring = true

func stop_alt_fire():
	altfiring = false

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
	bullet.damage= bullet_damage
	bullet.chargeearned = 2
	get_tree().current_scene.add_child(bullet)

func spawnHitscanBullet():
	beam.monitoring = true
	if ray.is_colliding():
		var collider = ray.get_collider()
		var trail = bullet_trail.instantiate()
		get_tree().current_scene.add_child(trail)
		trail.setup(muzzle.global_position, ray.get_collision_point())
	else:
		var trail = bullet_trail.instantiate()
		get_tree().current_scene.add_child(trail)
		trail.setup(muzzle.global_position, ray_end.global_position)
	await get_tree().create_timer(0.1).timeout
	beam.monitoring = false


func _on_beam_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		body.hit(100.0)
