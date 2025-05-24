extends State
var state_name = "run"
var RUNSPEED = 9
var climb_ray: RayCast3D

func Enter():
	Global.player.desired_speed = RUNSPEED


func Physics_Update(_delta : float):
	Global.player.reset_camera_rot(_delta)
	Global.player.ground_movement()
	climb_ray = Global.player.raycast_front
	if Input.is_action_pressed("jump"):
		Transitioned.emit(self, "jump")
	elif Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "slide")
	elif !Input.get_vector("left", "right", "forward", "backward"):
		Global.player.desired_speed = 0
		Transitioned.emit(self, "idle")
	elif climb_ray.is_colliding() && Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "climb")
