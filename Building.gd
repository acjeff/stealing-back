extends Area3D

@export var wall_nodes: Array[Node]
@export var wall_nodes_group_name: String = "wall"

func _ready():
	for child in get_parent().get_children():
		if child.is_in_group("wall"):
			wall_nodes.append(child)
		for cchild in child.get_children():
			if cchild.is_in_group("wall"):
				wall_nodes.append(cchild)
	# Find all nodes in the group "wall"
	#print("Wall nodes found: ", wall_nodes.size())
	for wall in wall_nodes:
		print("Wall node: ", wall.name)
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	print("Body entered: ", body.name)
	if body.is_in_group("player"):
		print("Player entered")
		toggle_walls(false)

func _on_body_exited(body):
	print("Body exited: ", body.name)
	if body.is_in_group("player"):
		print("Player exited")
		toggle_walls(true)

func toggle_walls(visible):
	print("Toggling walls, visible: ", visible)
	for wall in wall_nodes:
		print("Toggling wall: ", wall.name)
		if wall:
			if visible:
				wall.show()
			else:
				wall.hide()
		else:
			print("No material override for wall: ", wall.name)
