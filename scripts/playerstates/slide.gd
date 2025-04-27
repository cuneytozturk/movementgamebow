extends State

@onready var anims: AnimationPlayer = $"../../AnimationPlayer"
@onready var ceiling_check: ShapeCast3D = $"../../ceiling_check"

@export var ANIM_SPEED = 7
@export var SLIDE_SPEED = 0
@export var SLIDE_DECEL = 5

var timer := 0.0
var slide_direction := Vector3.ZERO

@export var camera_tilt_angle := 10.0
@export var tilt_speed := 5.0

func Enter():
	Global.player.allow_dir=false
	anims.play("crouch", -1, ANIM_SPEED)
	Global.player.desired_speed = SLIDE_SPEED
	Global.player.current_speed = Global.player.current_speed * 1.6
	Global.player.deceleration = SLIDE_DECEL
	
	# Lock in slide direction based on current movement
	slide_direction = Global.player.velocity
	slide_direction.y = 0
	slide_direction = slide_direction.normalized()

func Physics_Update(_delta : float):
	var camera_dir = clamp(Global.player.velocity.x, -1.0, 1.0)
	var target_roll = deg_to_rad(camera_tilt_angle * camera_dir)
	var current_roll = Global.player.camera_tilt.rotation.z
	Global.player.camera_tilt.rotation.z = lerp_angle(current_roll, target_roll, _delta * tilt_speed)
	Global.player.ground_movement()

	
	move()
	if !Input.is_action_pressed("crouch") and !ceiling_check.is_colliding():
		Transitioned.emit(self, "run")
	elif Input.is_action_pressed("jump") and !ceiling_check.is_colliding():
		
		Transitioned.emit(self, "jump")
		
func move():
	Global.player.velocity.x = slide_direction.x * Global.player.current_speed
	Global.player.velocity.z = slide_direction.z * Global.player.current_speed
	
func Exit():
	anims.play("crouch", -1, -ANIM_SPEED, true)
	Global.player.allow_dir=true
	Global.player.deceleration = 3
