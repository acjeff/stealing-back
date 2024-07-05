# Building.gd
extends Node3D

@onready var static_body = $StaticBody3D
@onready var collision_shape = static_body.get_node("CollisionShape3D")

func _ready():
	# Combine CSG nodes into one mesh
	var walls_mesh = ArrayMesh.new()
	var walls_csg = $Walls
	walls_csg.operation = CSGShape.OPERATION_UNION  # Ensure it's set to union for proper merging
	walls_csg.update_shape()
	var walls_array = walls_csg.mesh.surface_get_arrays(0)
	walls_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, walls_array)

	# Create the concave polygon shape from the combined mesh
	var trimesh_shape = PhysicsServer3D.shape_create(PhysicsServer3D.SHAPE_CONCAVE_POLYGON)
	PhysicsServer3D.shape_set_data(trimesh_shape, walls_mesh.create_trimesh_shape().get_faces())
	collision_shape.shape = trimesh_shape
