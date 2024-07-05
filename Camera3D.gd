extends Camera3D

@export var transparent_material: Material
@export var player_path: NodePath

var player
var original_materials = {}

func _ready():
	player = get_node(player_path)
	if not transparent_material:
		transparent_material = preload("res://transparent_material.tres")

func _process(delta):
	var from = global_transform.origin
	var to = player.global_transform.origin
	var space_state = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.collision_mask = 2  # Adjust this if you use specific layers for walls

	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.collider
		if collider is MeshInstance3D:
			var mesh_instance = collider as MeshInstance3D
			if mesh_instance.mesh and mesh_instance.mesh.surface_get_material(0) != transparent_material:
				if not original_materials.has(mesh_instance):
					original_materials[mesh_instance] = mesh_instance.mesh.surface_get_material(0)
				mesh_instance.mesh.surface_set_material(0, transparent_material)
	# Reset materials if no longer blocking view
	for mesh_instance in original_materials.keys():
		if mesh_instance != result.collider:
			mesh_instance.mesh.surface_set_material(0, original_materials[mesh_instance])
			original_materials.erase(mesh_instance)
