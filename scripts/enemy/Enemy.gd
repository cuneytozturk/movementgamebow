extends CharacterBody3D
class_name Enemy

@export var move_speed: float
@export var health:= 30
@export var target: CharacterBody3D
@export var THINK_INTERVAL: int
var frame_counter = 0
@export var score_earned: int

func _physics_process(delta):
	frame_skip(delta)
	move_and_slide()
	
func frame_skip(delta):
	frame_counter+= 1
	if frame_counter % THINK_INTERVAL == 0:
		physics_logic(delta)
	
func physics_logic(_delta):
	pass

func hit(_dmg):
	pass

func die(score_earned):
	Global.player.earnkill(score_earned)
