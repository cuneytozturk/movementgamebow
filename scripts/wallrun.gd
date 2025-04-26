extends State

@export var wallrun_cooldown = 1
@export var camera_tilt_angle := 10.0
@export var tilt_speed := 5.0
@export var WALLRUNSPEED = 14
@onready var camera_tilt: Node3D = $"../../camera_mount/camera_tilt"

func Enter():
	Global.player.desired_speed = WALLRUNSPEED

func Physics_Update(_delta : float):
	var tilt_direction = sign(Global.player.wall_direction.x)  # -1 = left wall, 1 = right wall
	var target_roll = deg_to_rad(camera_tilt_angle * tilt_direction)
	var current_roll = Global.player.camera_tilt.rotation.z
	Global.player.camera_tilt.rotation.z = lerp_angle(current_roll, target_roll, _delta * tilt_speed)
	Global.player.ground_movement()
	
	# suspend gravity during wallrun
	Global.player.velocity.y = 0
	# check if player is moving forwards
	var forward_input := Input.get_action_strength("forward")
	
	var forward = -Global.player.camera_mount.basis.z
	# avoids flying up/down by restricting y axis
	forward.y = 0
	forward = forward.normalized()
	Global.player.velocity.x = forward.x * Global.player.current_speed
	Global.player.velocity.z = forward.z * Global.player.current_speed
	
	# reset wallrun cooldown and > jump state
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "jump")
	
	# if no moving forward > exit wallrun state
	if forward_input < 0.1 or Global.player.wall_direction == Vector3.ZERO:
		Transitioned.emit(self, "run")

func Exit():
	Global.player.wallrun_cooldown_timer = wallrun_cooldown
