extends Container

var _columns = 4
@export var id: int
@export var item: Node3D
var item_name: String = ""
var item_icon: String = ""
var item_icon_color: String = ""
@onready var label = $Panel/VBoxContainer/Label
@onready var icon = $Panel/VBoxContainer/Icon

func get_grid_position(id: int, columns: int) -> Vector2:
	var x = (id - 1) % columns
	var y = (id - 1) / columns
	return Vector2(x, y)

func _ready():
	var grid = $"../.."
	var grid_position = get_grid_position(id, _columns)
	var x = grid_position.x
	var y = grid_position.y
	var grid_width = grid.size.x
	var grid_height = grid.size.y
	var cell_width = (grid_width / 4) - 3
	var cell_height = grid_height / 2
	var cell_x = cell_width * x
	var cell_y = cell_height * y
	print(cell_x, ' : cell x')
	print(cell_y, ' : cell y')
	$Panel.size.x = cell_width
	label.size.x = cell_width
	icon.size.x = cell_width
	$Panel/VBoxContainer.size.x = cell_width
	$Panel/VBoxContainer.size.y = cell_height
	$Panel.size.y = cell_height
	$Panel.position.x = cell_x
	$Panel.position.y = cell_y
	
	# Store the item name when the node is ready
	if is_instance_valid(item) and item.has_method("get_name"):
		item_name = item.item_name
		item_icon = item.item_icon
		item_icon_color = item.item_icon_color
	update_label()

func update_label():
	if label:
		label.text = item_name if item_name else ""
	if icon:
		icon.text = item_icon if item_icon else ""
		icon.add_theme_color_override("font_color", item_icon_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_label()

# Function to update item data
func set_item_data(new_item: Node3D):
	item = new_item
	if is_instance_valid(item) and item.has_method("get_name"):
		item_name = item.get_name()
	else:
		item_name = ""
	update_label()
