extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount
@onready var camera_tilt: Node3D = $camera_mount/camera_tilt
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape3D = $collision
@onready var ui: Control = $UI
@onready var statemachine: Node = $statemachine


# camera sensitivity
@export var SENS = 0.005
@export var tilt_speed := 5.0

# speed
@export var acceleration = 15
var deceleration = 7
@export var DEFAULT_DECEL = 7
var current_speed = 0.0
var desired_speed = 0.0
@export var speed_limit := 16
var direction := Vector3.ZERO
var air_direction := Vector3.ZERO
var input_dir := Vector2.ZERO
var desired_dir := Vector3.ZERO
var allow_dir := true
@export var air_control_strength = 1.5 # how much you can steer in air (30%)

# wallrun vars
@onready var raycast_left: RayCast3D = $camera_mount/raycast_left
@onready var raycast_right: RayCast3D = $camera_mount/raycast_right
@onready var raycast_leftbutt: RayCast3D = $camera_mount/raycast_leftbutt
@onready var raycast_rightbutt: RayCast3D = $camera_mount/raycast_rightbutt
@onready var raycast_front: RayCast3D = $camera_mount/raycast_front
var wallrun_ground_timer := 0.0
@export var wallrun_cooldown_timer: float
var wall_direction

#headbob vars
var t_bob = 0.0
@export var BOB_FREQ = 2.0
@export var BOB_AMP = 0.08

# fov vars
@export var BASE_FOV = 75.0
var FOV_CHANGE = 1.5

# hero vars
var current_weapon: BaseWeapon
@export var health = 100
var charge = 0
@export var max_charge = 30
var run_score := 0


func _ready() -> void:
	Global.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equip_weapon(load("res://scenes/hand.tscn"))
	#equip_weapon(load("res://scenes/bow.tscn"))
func _unhandled_input(event: InputEvent) -> void:
	# handle mouse input for camera
	if event is InputEventMouseMotion:
		camera_mount.rotate_y(-event.relative.x * SENS)
		camera_mount.xrot.rotate_x(-event.relative.y * SENS)
		camera_mount.xrot.rotation.x = clamp(camera_mount.xrot.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if current_weapon:
		if event.is_action_pressed("mouseleft"):
				equip_weapon(load("res://scenes/hand.tscn"))
				current_weapon.start_fire()
		elif event.is_action_released("mouseleft"):
			current_weapon.stop_fire()
		elif event.is_action_pressed("mouseright"):
				equip_weapon(load("res://scenes/bow.tscn"))
				current_weapon.start_alt_fire()
		elif event.is_action_released("mouseright"):
			current_weapon.stop_alt_fire()

func equip_weapon(weapon_scene: PackedScene):
	if current_weapon:
		current_weapon.queue_free()
	current_weapon = weapon_scene.instantiate()
	camera_mount.weapon_mount.add_child(current_weapon)

func _physics_process(delta: float) -> void:
	speed_fov_change(delta)
	wallrun_cooldowns(delta)
	acceldeccel(delta)
	# apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# block player input but allow movement to continue
	if allow_dir:
		headbob(delta)
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		desired_dir = (camera_mount.basis * Vector3(input_dir.x, 0, input_dir.y))
	else:
		input_dir = Vector2.ZERO
		direction = Vector3.ZERO

	# move player in direction * current_speed ELSE lerp to 0 by decel
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * deceleration)
		velocity.z = lerp(velocity.z, 0.0, delta * deceleration)
		
	move_and_slide()

func ground_movement():
	direction = desired_dir.normalized()
	air_direction = direction

func air_movement(delta):
	var desired = desired_dir.normalized()
	if desired.length() > 0:
		air_direction += desired * air_control_strength * delta
		# Optional: Clamp to max air direction length
		#air_direction = clamp(air_direction, 0.0, 1.0)
	direction = air_direction.normalized()

func headbob(delta): 
	var pos = Vector3.ZERO
	var time = t_bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	camera_mount.camera.transform.origin = pos
	
func speed_fov_change(delta):
	var velocity_clamped = clamp(velocity.length(), 0.5, 10 * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera_mount.camera.fov = lerp(camera_mount.camera.fov, target_fov, delta * 8)

func wallrun_cooldowns(delta):
	if wallrun_cooldown_timer > 0:
		wallrun_cooldown_timer -= delta
	if is_on_floor(): #or wall_direction == Vector3.ZERO:
		wallrun_ground_timer = 0.0
	else:
		wallrun_ground_timer += delta
	wall_direction = get_wall_direction()

func get_wall_direction() -> Vector3:
	if raycast_left.is_colliding() or raycast_leftbutt.is_colliding():
		return -global_transform.basis.x
	elif raycast_right.is_colliding() or raycast_rightbutt.is_colliding():
		return global_transform.basis.x
	else:
		return Vector3.ZERO

func acceldeccel(delta):
	#accel/decel
	if current_speed < desired_speed:
			current_speed += acceleration * delta
			current_speed = min(current_speed, desired_speed)
	elif current_speed > desired_speed:
		current_speed -= deceleration * delta
		current_speed = max(current_speed, desired_speed)
	current_speed = clamp(current_speed, 0, speed_limit)

func reset_camera_rot(delta):
	var current_roll = camera_tilt.rotation.z
	camera_tilt.rotation.z  = lerp_angle(camera_tilt.rotation.z, 0.0, delta * tilt_speed)



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		print("ow")
		health -= 30
		if health <= 0:
			print("Dead")
			position = Vector3(0, 3, 0)
			health = 100

func earncharge(chargeearned):
	if charge <= max_charge:
		charge += chargeearned
func earnkill(score):
	var state = statemachine.current_state.state_name
	if state == "slide":
		ui.add_entry("slidekill", score*1.2)
		run_score += score * 1.2
	elif wallrun_cooldown_timer >= 0:
		ui.add_entry("wallshot", score*1.5)
		run_score += score * 1.5
	elif state == "jump":
		ui.add_entry("jumpshot", score*1.1)
		run_score += score * 1.1
	else:
		ui.add_entry("kill", score)
		run_score += score
	ui.run_score.set_text(str(run_score))
