extends Container
var _columns = 4
@export var id: int
@export var item_id: int

func get_grid_position(id: int, columns: int) -> Vector2:
	var x = (id - 1) % columns
	var y = (id - 1) / columns
	return Vector2(x, y)

# Called when the node enters the scene tree for the first time.
func _ready():
	var grid = $"../.."
	var grid_position = get_grid_position(id, _columns)
	var x = grid_position.x
	var y = grid_position.y
	var grid_width = grid.size.x
	var grid_height = grid.size.y
	var cell_width = grid_width / 4
	var cell_height = grid_height / 2
	var cell_x = cell_width * x
	var cell_y = cell_height * y
	$Panel.size.x = cell_width
	$Panel.size.y = cell_height
	$Panel.position.x = cell_x
	$Panel.position.y = cell_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Panel/Label.text = 'Item text'
	pass
