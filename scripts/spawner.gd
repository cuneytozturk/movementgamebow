extends Node3D
var skull = preload("res://scenes/skull.tscn")
var ghoul = preload("res://scenes/ghoul.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var player: CharacterBody3D = $"../player"
@onready var groundspawner: Node3D = $groundspawner
@onready var airspawner: Node3D = $airspawner
@export var health: float = 200

var airblocked: bool = false

# Define the waves
var waves = [
	{"skull": 5, "ghoul": 5}  # Wave 3
]

# Time between spawns and between waves
var spawn_delay = 0.5  # Delay between each enemy spawn
var wave_delay = 15  # Delay between waves
var current_wave = 0   # The index of the current wave

# Ready function to initialize everything
func _ready():
	start_wave()

func hit(damage: float):
	health-=damage
	if health <= 0:
		queue_free()
	

# Function to start the current wave
func start_wave():
	var wave = waves[current_wave]
	print(wave)
	spawn_wave(wave)

# Function to spawn the enemies in a wave
func spawn_wave(wave):
	var _total_spawned = 0
	for enemy_type in wave.keys():
		var amount = wave[enemy_type]
		for i in range(amount):
			# Spawn each enemy with a delay
			match enemy_type:
				"skull":
					if not airblocked:
						spawn_enemy(skull, airspawner)
				"ghoul":
					spawn_enemy(ghoul, groundspawner)
			_total_spawned += 1
			await get_tree().create_timer(spawn_delay).timeout

	# After spawning all enemies, wait for the next wave
	await get_tree().create_timer(wave_delay).timeout
	current_wave += 1
	if current_wave < waves.size():
		start_wave()
	else:
		current_wave=0
		start_wave()

# Function to spawn a single enemy
func spawn_enemy(enemy_scene: PackedScene, spawnpoints: Node3D) -> void:
	var spawners = spawnpoints.get_children()
	var total_spawners = spawners.size()

	while true:
		var start_index = randi() % total_spawners  # Random starting index

		# Try all spawn points starting from random index
		for i in range(total_spawners):
			var spawner = spawners[(start_index + i) % total_spawners]
			var spawncol: Area3D = spawner.get_node_or_null("Area3D")
			if spawncol == null:
				continue

			await get_tree().process_frame

			if spawncol.get_overlapping_bodies().is_empty():
				# get v3 of spawner global pos. 
				var world: Node3D = get_parent_node_3d()
				var spawner_global_pos: Vector3 = spawner.to_global(spawner.position)
				# v3 of local point from global spawner pos
				var enemy_local_pos: Vector3 = world.to_local(spawner_global_pos)             # global → world local
				var enemy = enemy_scene.instantiate()
				enemy.position = spawner_global_pos
				enemy.target = player
				world.add_child(enemy)
				return  # Spawned successfully

		# No free spawner found, wait and retry
		await get_tree().create_timer(0.2).timeout
