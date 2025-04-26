extends Node3D
var skull = preload("res://scenes/skull.tscn")
var spawned
var wave := 0
@onready var rand = RandomNumberGenerator.new()
@onready var player: CharacterBody3D = $"../player"


func _on_timer_timeout() -> void:
		spawned = skull.instantiate()
		spawned.player = player
		var spawner = get_child(randi() % get_child_count())
		spawned.position = spawner.global_position
		get_tree().current_scene.add_child(spawned)
