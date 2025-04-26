extends BaseWeapon
@onready var muzzle: Node3D = $muzzle
var bullet_scene : PackedScene

var firing = false
var can_fire = true



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
	bullet.transform.basis = muzzle.global_transform.basis
	get_tree().current_scene.add_child(bullet)
