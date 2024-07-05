# InventoryUI.gd
extends CanvasLayer

@onready var inventory_container = $VBoxContainer

func update_inventory(inventory):
	# Clear previous items
	for child in inventory_container.get_children():
		child.queue_free()
	# Add new items
	for item in inventory:
		if is_instance_valid(item):  # Check if the item reference is still valid
			var label = Label.new()
			label.text = "Item: " + item.item_name  # Display the item name
			inventory_container.add_child(label)
