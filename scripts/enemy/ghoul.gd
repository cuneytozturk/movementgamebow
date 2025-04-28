extends Enemy

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready():
	move_speed = 10
	THINK_INTERVAL = 30
	health = 100

func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()

func physics_logic(delta):
	if not target:
		return
		
	# Set the target position (player's position)
	navigation_agent.set_target_position(target.global_transform.origin)

	# Get next path point
	var next_path_position = navigation_agent.get_next_path_position()

	# Move toward next path point
	var to_target = next_path_position - global_transform.origin
	to_target.y = 0  # Stay on ground
	to_target = to_target.normalized()

	velocity.x = to_target.x * move_speed
	velocity.z = to_target.z * move_speed

	# Apply gravity
	if not is_on_floor():
		velocity.y -= 30.0 * delta  # Increase gravity if needed
	else:
		velocity.y = 0

	# Rotate to face movement direction
	if velocity.length() > 0.1:
		look_at(Vector3(global_transform.origin.x + velocity.x, global_transform.origin.y, global_transform.origin.z + velocity.z), Vector3.UP)
