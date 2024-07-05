extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var polygon = PackedVector2Array([
	Vector2(0, 0),       # Bottom-left corner
	Vector2(1, 1),       # First step
	Vector2(2, 2),
	Vector2(3, 3),
	Vector2(4, 4),
	Vector2(5, 5),
	Vector2(6, 6),
	Vector2(7, 7),
	Vector2(8, 8),
	Vector2(9, 9),
	Vector2(10, 10),
	Vector2(11, 11),
	Vector2(12, 12),
	Vector2(13, 13),
	Vector2(14, 14),
	Vector2(15, 15),     # Top-right corner
	Vector2(15, 0)       # Bottom-right corner
])

	# Create the collision shape
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = polygon

	# Add the collision shape to your node
	add_child(collision_shape)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
