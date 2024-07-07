# InventoryUI.gd
extends CanvasLayer
var inventory_space = preload("res://inventory_space.tscn")

@onready var inventory_container = $Panel/InventoryGrid

func update_inventory(inventory):
	print("Inventory size: ", inventory.size())
	# Clear previous items
	#for child in inventory_container.get_children():
		#child.queue_free()
	# Add new items
	for index in range(inventory.size()):
		var item = inventory[index]
		if is_instance_valid(item):
			var item_to_add = inventory_space.instantiate()
			item_to_add.id = index + 1
			item_to_add.set_item_data(item)
			$Panel/InventoryGrid.add_child(item_to_add)
