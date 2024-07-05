extends StaticBody3D

@export var ui_path: NodePath

func _ready():
	var ui = get_node(ui_path)
	#ui.visible = false

func _on_interact():
	print("Open PC Menu")
	var ui = get_node(ui_path)
	ui.visible = true
