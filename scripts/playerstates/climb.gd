extends State
var state_name = "climb"
var climb_ray: RayCast3D
var max_climb_speed = 6.0
var min_climb_speed = 0.5
var climb_duration = 1.5 # seconds until climbing loses full strength
var climb_timer = 0.0


func Enter():
	pass

func Physics_Update(_delta : float):
	Global.player.ground_movement()
	Global.player.velocity.y = 0
	climb_timer += _delta
	var t = clamp(climb_timer / climb_duration, 0, 1)
	var climb_speed = lerp(max_climb_speed, min_climb_speed, t)
	Global.player.velocity.y = climb_speed
	
	climb_ray = Global.player.raycast_front
	if !climb_ray.is_colliding() || Input.is_action_just_released("jump"):
		Transitioned.emit(self, "run")


func Exit():
	climb_timer = 0.0
