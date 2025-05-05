extends Node3D
var skull = preload("res://scenes/skull.tscn")
var ghoul = preload("res://scenes/ghoul.tscn")
@onready var rand = RandomNumberGenerator.new()
@onready var player: CharacterBody3D = $"../player"



# Define the waves
var waves = [
	{"skull": 100, "ghoul": 100}, # Wave 1
	{"skull": 30, "ghoul": 30},   # Wave 2
	{"skull": 100, "ghoul": 100},   # Wave 3
]

# Time between spawns and between waves
var spawn_delay = 0.5  # Delay between each enemy spawn
var wave_delay = 10  # Delay between waves
var current_wave = 0   # The index of the current wave


# Ready function to initialize everything
func _ready():
	pass#start_wave()

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
					spawn_enemy(skull, 0)
				"ghoul":
					spawn_enemy(ghoul, 1)
			_total_spawned += 1
			await get_tree().create_timer(spawn_delay).timeout

	# After spawning all enemies, wait for the next wave
	await get_tree().create_timer(wave_delay).timeout
	current_wave += 1
	if current_wave < waves.size():
		start_wave()
	else:
		print("All waves completed!")

# Function to spawn a single enemy
func spawn_enemy(enemy_scene: PackedScene, spawnlist: int):
	var enemy = enemy_scene.instantiate()
	var spawnpoints = get_child(spawnlist)
	var spawner = spawnpoints.get_child(randi() % spawnpoints.get_child_count())
	enemy.position = spawner.global_position
	enemy.target = player
	add_child(enemy)
