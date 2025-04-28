extends MeshInstance3D

var alpha = 1.0


func _ready():
	var dup_mat = material_override.duplicate()
	material_override = dup_mat

func init(pos1, pos2):
	var dir = (pos2 - pos1).normalized()
	var distance = pos1.distance_to(pos2)
	var mid_point = (pos1 + pos2) * 0.5

	var up = Vector3.UP
	if abs(dir.dot(up)) > 0.99:
		up = Vector3.FORWARD

	var right = dir.cross(up).normalized()
	var real_up = right.cross(dir).normalized()

	var basis = Basis(right, real_up, dir)
	global_transform = Transform3D(basis, mid_point)
	scale = Vector3(0.05, 0.05, distance * 0.5) # z is half-length
