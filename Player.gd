extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 3.0
@export var bag_capacity: float = 10.0
@export var weight: float = 75.0  # Weight of the player
@export var strength: float = 100.0  # Strength of the player for moving items
@export var interaction_radius: float = 2.0
@export var transparent_material: Material
@export var ui_path: NodePath
@export var npc_manager_path: NodePath
@onready var phone = $"../../../Phone"

var bag_weight: float = 0.0
var inventory: Array = []
var dragging_item: RigidBody3D = null
var nearby_item = null  # Store the reference to the nearby item
var drag_joint: PinJoint3D = null
var current_mission = null
var original_materials = {}

# Reference to the Inventory UI
@onready var inventory_ui = get_tree().get_root().get_node("Main/InventoryUI")

# Reference to the Pickup Prompt UI
@onready var pickup_prompt_ui = get_tree().get_root().get_node("Main/PickupPromptUI")

# Reference to the NPC Manager
@onready var npc_manager = get_node(npc_manager_path)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group("player")
	var area = $Area3D  # Path to your Area3D node
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	else:
		print("Area3D node not found")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var move_direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		move_direction += -transform.basis.z
	if Input.is_action_pressed("move_backwards"):
		move_direction += transform.basis.z

	# Handle rotation.
	if Input.is_action_pressed("move_right"):
		rotation.y -= ROTATION_SPEED * delta
	if Input.is_action_pressed("move_left"):
		rotation.y += ROTATION_SPEED * delta

	# Calculate the total weight the player is trying to move.
	var total_weight = bag_weight
	if dragging_item:
		total_weight += dragging_item.get("weight")

	# Check if the player can move the total weight.
	if total_weight <= weight:
		if move_direction != Vector3.ZERO:
			velocity.x = move_direction.x * SPEED
			velocity.z = move_direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

	if dragging_item:
		print("Dragging item: ", dragging_item)

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("drag") and nearby_item:
			if dragging_item:
				print("Stopping dragging item")
				stop_dragging()
			else:
				print("Starting to drag item")
				start_dragging()
		elif Input.is_action_just_released("drag") and dragging_item:
			print("Stopping dragging item")
			stop_dragging()

		if Input.is_action_just_pressed("pick_up") and nearby_item:
			if nearby_item.is_in_group("Item"):
				pick_up(nearby_item)

		if Input.is_action_just_pressed("torch"):
			$Torch.visible = !$Torch.visible

		if Input.is_action_just_pressed("togglePhone"):
			phone.visible = !phone.visible

		if Input.is_action_just_pressed("interact") and nearby_item:
			if nearby_item.has_method("_on_interact"):
				nearby_item._on_interact()

func start_dragging():
	dragging_item = nearby_item
	if dragging_item and dragging_item.get("weight") <= strength:
		drag_joint = PinJoint3D.new()
		drag_joint.node_a = get_path()
		drag_joint.node_b = dragging_item.get_path()
		add_child(drag_joint)
		if dragging_item.has_method("set_dragging"):
			dragging_item.call("set_dragging", true, self)

func stop_dragging():
	if dragging_item:
		if dragging_item.has_method("set_dragging"):
			dragging_item.call("set_dragging", false, null)
		if drag_joint:
			drag_joint.queue_free()
			drag_joint = null
		dragging_item = null

func _on_body_entered(body):
	print("Body entered: ", body)
	if body.is_in_group("interactable"):
		nearby_item = body
		print("Nearby item: ", nearby_item)
	elif body.is_in_group("Item"):
		nearby_item = body
		print("Nearby item: ", nearby_item)
		pickup_prompt_ui.show_prompt()

func _on_body_exited(body):
	print("Body exited: ", body)
	if body == nearby_item:
		nearby_item = null
	if body.is_in_group("Item"):
		pickup_prompt_ui.hide_prompt()
	if body == dragging_item:
		print("Stopped dragging item")
		stop_dragging()

func pick_up(item):
	var item_name = item.item_name  # Store item name before freeing
	if item.weight + bag_weight <= bag_capacity:
		inventory.append(item)  # Store the item instance
		bag_weight += item.weight
		print("Picked up item: ", item_name)
		item.queue_free()  # Removes the item from the world
		inventory_ui.update_inventory(inventory)  # Update the inventory UI
		pickup_prompt_ui.hide_prompt()  # Hide the pickup prompt
	else:
		print("Bag is full, cannot pick up more items!")

func has_item(item_id):
	for item in inventory:
		if item.item_id == item_id:
			return true
	return false

func remove_item(item_id):
	for item in inventory:
		if item.item_id == item_id:
			inventory.erase(item)
			return

func accept_mission(mission):
	current_mission = mission

func complete_mission():
	if current_mission:
		# Check if the item is in the inventory
		var item_id = current_mission["item_id"]
		if has_item(item_id):
			# Find the NPC and complete the mission
			var npc_id = current_mission["npc_id"]
			var npc = npc_manager.find_npc_by_id(npc_id)
			if npc:
				npc.receive_item(item_id)
				remove_item(item_id)
				current_mission = null
				print("Mission Completed")
