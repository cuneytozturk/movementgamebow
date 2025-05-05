extends Node

class_name BaseWeapon

@export var weapon_name: String = "DefaultWeapon"
@export var damage: int = 10
@export var fire_rate: float = 0.5 # seconds between shots

var firing = false
var can_fire = true
var altfiring = false
var can_alt_fire = true

func start_fire():
	pass
func stop_fire():
	pass
func start_alt_fire():
	pass
func stop_alt_fire():
	pass
