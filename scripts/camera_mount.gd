extends Node3D
@onready var camera: Camera3D = $camera_tilt/shakeable_camera/xrot/camera
@onready var middlepoint: RayCast3D = $camera_tilt/shakeable_camera/xrot/camera/middlepoint
@onready var misspoint: Node3D = $camera_tilt/shakeable_camera/xrot/camera/misspoint
@onready var weapon_mount: Node3D = $camera_tilt/shakeable_camera/xrot/camera/weapon_mount
@onready var xrot: Node3D = $camera_tilt/shakeable_camera/xrot
@onready var shakeable_camera: Area3D = $camera_tilt/shakeable_camera
