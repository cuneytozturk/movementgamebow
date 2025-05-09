extends State
var state_name = "idle"
func Enter():
	pass

func Physics_Update(_delta : float):
	Global.player.ground_movement()
	Global.player.reset_camera_rot(_delta)
	
	if Input.get_vector("left", "right", "forward", "backward") and Global.player.is_on_floor() :
		Transitioned.emit(self, "run")
	elif Input.is_action_pressed("jump"):
		Transitioned.emit(self, "jump")
	elif Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "slide")
