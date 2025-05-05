extends Node3D

@export var thickness = 0.3
@onready var mesh: MeshInstance3D = $MeshInstance3D
var mat

func _ready() -> void:
	mat = mesh.get_active_material(0)
	mat = mat.duplicate()
	mesh.set_surface_override_material(0, mat)

func _process(delta: float) -> void:
	if mat:
		var color = mat.albedo_color
		color.a = clamp(color.a - delta * 1, 0.0, 1.0)  # Fades out over 2 seconds
		mat.albedo_color = color
		if color.a <= 0:
			queue_free()
	
func setup(start_pos: Vector3, end_pos: Vector3):
	global_transform.origin = start_pos #place mesh at start pos
	look_at(end_pos, Vector3.UP) #point meshs up dir towards end pos
	var dir = end_pos - start_pos #get direction towards end pos
	var distance = dir.length() 
	mesh.scale = Vector3(thickness, distance * 0.5, thickness) # cylinder height is 2 by default, hence *0.5
	global_transform.origin = start_pos.lerp(end_pos, 0.5)
