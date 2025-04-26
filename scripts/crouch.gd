extends State

@onready var anims: AnimationPlayer = $"../../AnimationPlayer"
@onready var ceiling_check: ShapeCast3D = $"../../ceiling_check"

@export var CROUCH_SPEED = 7
@export var CROUCH_MOVEMENT_SPEED = 3




func Enter():
	anims.play("crouch", -1, CROUCH_SPEED)
	Global.player.max_speed = CROUCH_MOVEMENT_SPEED

func Physics_Update(_delta : float):
	
	if !Input.is_action_pressed("crouch") and !ceiling_check.is_colliding():
		Transitioned.emit(self, "run")
	elif Input.is_action_pressed("jump") and !ceiling_check.is_colliding():
		Transitioned.emit(self, "jump")

func Exit():
	anims.play("crouch", -1, -CROUCH_SPEED, true)
