extends BaseWeapon
@onready var muzzle: Node3D = $muzzle
var bullet_scene : PackedScene

func _ready():
	bullet_scene = load("res://scenes/akbullet.tscn")
	
func fire():
	print(muzzle.global_transform.basis)
	spawnBullet()

func spawnBullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position
	bullet.transform.basis = muzzle.global_transform.basis
	get_tree().current_scene.add_child(bullet)
