extends Camera3D

@export var player_path: NodePath
@export var mask_mesh_path: NodePath
var player
var mask_mesh

func _ready():
	player = get_node(player_path)
	mask_mesh = get_node(mask_mesh_path)
	mask_mesh.set_shader_parameter("player_position", player.global_transform.origin)

func _process(delta):
	if player:
		global_transform.origin = player.global_transform.origin + Vector3(0, 5, 0)
		look_at(player.global_transform.origin, Vector3.UP)
		mask_mesh.set_shader_parameter("player_position", player.global_transform.origin)
