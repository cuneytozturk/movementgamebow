extends State

@export var JUMP_VELOCITY = 6
@export var JUMP_AIR_SPEED = 8
@export var wallrun_delay = 0.2
@export var JUMP_DECEL = 1
var state_name = "jump"

var climb_ray: RayCast3D

func Enter():
	Global.player.desired_speed = JUMP_AIR_SPEED
	Global.player.velocity.y += JUMP_VELOCITY
	Global.player.deceleration = JUMP_DECEL

func Physics_Update(_delta : float):
	Global.player.reset_camera_rot(_delta)
	Global.player.air_movement(_delta)
	
	if Global.player.is_on_floor():
		Transitioned.emit(self, "run")
	
	# if next to wall, past wallrun ground delay, past wallrun cooldown > wallrun state
	if Global.player.wall_direction != Vector3.ZERO \
	and Global.player.wallrun_ground_timer >= wallrun_delay \
	and Global.player.wallrun_cooldown_timer <= 0.0:
		Transitioned.emit(self, "wallrun")
		
	climb_ray = Global.player.raycast_front
	if climb_ray.is_colliding() && Input.is_action_pressed("jump"):
		Transitioned.emit(self, "climb")

func Exit():
	Global.player.deceleration = Global.player.DEFAULT_DECEL
