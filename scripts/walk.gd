extends State


@export var tilt_speed := 5.0

func Enter():
	Global.player.max_speed = Global.player.DEFAULTSPEED

func Physics_Update(_delta : float):
	# reset rotation of camera from previous state
	var current_roll = Global.player.camera.rotation.z
	Global.player.camera.rotation.z = lerp_angle(current_roll, 0.0, _delta * tilt_speed)
	 
	if Global.player.velocity.length() < 0.1:
		Transitioned.emit(self, "idle")
	elif Input.is_action_pressed("run"):
		Transitioned.emit(self, "run")
	elif Input.is_action_pressed("jump") and Global.player.is_on_floor():
		Transitioned.emit(self, "jump")
	elif Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "slide")
