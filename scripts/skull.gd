extends CharacterBody3D

@export var move_speed: float = 7.0
@export var turn_speed: float = 2.0
@export var hover_amplitude: float = 0.5
@export var hover_speed: float = 2.0

@export var health:= 30


var player: CharacterBody3D
var hover_offset := 0.0

func _ready():
	#passplayer = get_node(player_path)
	pass

var frame_counter := 0
const THINK_INTERVAL := 40 # seconds between "thinking" (10 times per second)

func _physics_process(delta):
	frame_counter+= 1
	if frame_counter % THINK_INTERVAL == 0:
		look_at(player.global_transform.origin, Vector3.UP)
		velocity = -global_transform.basis.z * move_speed
	move_and_slide()
	
	
func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
