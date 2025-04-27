extends Node

class_name BaseWeapon

@export var weapon_name: String = "DefaultWeapon"
@export var damage: int = 10
@export var fire_rate: float = 0.5 # seconds between shots

func start_fire():
	pass
func stop_fire():
	pass
