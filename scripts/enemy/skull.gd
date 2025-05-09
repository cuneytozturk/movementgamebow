extends Enemy

@export var turn_speed: float = 2.0
@export var hover_amplitude: float = 0.5
@export var hover_speed: float = 2.0


var hover_offset := 0.0

func _ready():
	move_speed = 9
	THINK_INTERVAL = 30
	health = 60

func _physics_process(delta):
	frame_skip(delta)
	move_and_slide()
	
func frame_skip(delta):
	frame_counter+= 1
	if frame_counter % THINK_INTERVAL == 0:
		physics_logic(delta)
	
func physics_logic(_delta):
	look_at(target.global_transform.origin, Vector3.UP)
	velocity = -global_transform.basis.z * move_speed

func hit(dmg):
	health -= dmg
	if health <= 0:
		die(score_earned)
		queue_free()
