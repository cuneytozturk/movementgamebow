extends CharacterBody3D

@export var move_speed: float = 7.0
@export var turn_speed: float = 4.0
@export var hover_amplitude: float = 0.5
@export var hover_speed: float = 2.0
@export var player_path: NodePath

var player: CharacterBody3D
var hover_offset := 0.0

func _ready():
	player = get_node(player_path)

func _physics_process(delta):
	

	# 🧠 Look at player
	var to_player = (player.global_transform.origin - global_transform.origin).normalized()
	var target_rotation = global_transform.looking_at(player.global_transform.origin, Vector3.UP).basis
	global_transform.basis = global_transform.basis.slerp(target_rotation, delta * turn_speed)

	# 💨 Move toward player
	velocity = -global_transform.basis.z * move_speed
	move_and_slide()

	# ☁️ Add floating bobbing motion
	hover_offset += delta * hover_speed
	var y_offset = sin(hover_offset) * hover_amplitude
	translate(Vector3(0, y_offset * delta, 0))
