extends Node
@onready var s1: Node3D = $spawnerarea
@onready var s2: Node3D = $spawnerarea2
@onready var s3: Node3D = $spawnerarea3
@onready var s4: Node3D = $spawnerarea4
@onready var s5: Node3D = $spawnerarea5
@onready var s6: Node3D = $spawnerarea6

const SPAWN = preload("res://scenes/spawner.tscn")
var spawn_schedule = {}


var time_passed := 0.0
var next_times := []

func _ready():
	spawn_schedule = {
		5.0: s1,
		10.0: s1,
		20.0: s2,
		30.0: s6,
		40.0: s3,
		50.0: s4,
		60.0: s1,
		70.0: s5,
		80.0: s2,
		90.0: s1,
		100.0: s4,
		110.0: s1,
		120.0: s2,
		130.0: s3,
		140.0: s4,
		150.0: s1,
		160.0: s4,
		170.0: s3,
		180.0: s2,
		190.0: s1,
		200.0: s4,
	}
	next_times = spawn_schedule.keys()
	next_times.sort()

func _process(delta):
	time_passed += delta

	while !next_times.is_empty() and time_passed >= next_times[0]:
		var trigger_time = next_times.pop_front()
		var spawnarea = spawn_schedule[trigger_time]
		var spawner = SPAWN.instantiate()
		if spawnarea == s5 or spawnarea == s6:
			print("Airblock")
			spawner.airblocked = true
		else: 
			spawner.airblocked = false
		

		var base_pos = spawnarea.global_position
		var offset = Vector3(randf_range(-3.0, 3.0), 0, randf_range(-3.0, 3.0))
		spawner.position = base_pos + offset

		get_parent().add_child(spawner)
