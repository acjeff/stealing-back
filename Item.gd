# Item.gd
extends RigidBody3D

@export var item_id: int
@export var weight: float = 1.0
@export var value: float = 10.0
@export var item_name: String = "Default Item"

func _ready():
	add_to_group("Item")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	print("Body entered item: ", body)

func _on_body_exited(body):
	print("Body exited item: ", body)
