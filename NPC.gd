extends Node3D

@export var npc_id: int
@export var target_item_id: int
@export var move_speed = 5.0
@export var wander_time = 10.0
@export var return_threshold = 1.0
@export var min_wander_distance = 5.0  # Minimum distance to wander
@export var max_wander_distance = 20.0  # Maximum distance to wander

var start_position: Vector3
var target_position: Vector3
var wander_timer: float = 0.0
var is_returning: bool = false

@onready var dialogue_box = get_node("/root/Main/DialogueBox")  # Adjust the path to your dialogue UI
@onready var character_body: CharacterBody3D = $"."
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	$Area3D.body_entered.connect(_on_body_entered)
	$Area3D.body_exited.connect(_on_body_exited)
	start_position = character_body.global_position
	
	if not character_body or not navigation_agent:
		push_error("Required child nodes are missing. Please check the scene structure.")
		return
	
	set_new_target()

func _physics_process(delta):
	if not character_body or not navigation_agent:
		return
	
	if is_returning:
		navigate_to(start_position)
		if character_body.global_position.distance_to(start_position) < return_threshold:
			is_returning = false
			set_new_target()
	else:
		navigate_to(target_position)
		wander_timer += delta
		if wander_timer >= wander_time:
			is_returning = true
			wander_timer = 0.0
	
	if navigation_agent.is_navigation_finished():
		set_new_target()
		return
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = character_body.global_position.direction_to(next_position)
	
	character_body.velocity = direction * move_speed
	character_body.move_and_slide()
	
	#print("Current position: ", character_body.global_position, " Moving towards: ", next_position)
	
	if direction:
		character_body.look_at(character_body.global_position + direction, Vector3.UP)

func navigate_to(target: Vector3):
	navigation_agent.set_target_position(target)

func set_new_target():
	var current_position = character_body.global_position
	var random_offset: Vector3
	var attempts = 0
	
	while attempts < 10:  # Limit attempts to avoid infinite loop
		random_offset = Vector3(
			randf_range(-max_wander_distance, max_wander_distance),
			0,  # Assuming the character moves on a flat plane
			randf_range(-max_wander_distance, max_wander_distance)
		)
		var potential_target = current_position + random_offset
		
		if potential_target.distance_to(current_position) >= min_wander_distance:
			navigation_agent.set_target_position(potential_target)
			await get_tree().process_frame
			target_position = navigation_agent.get_final_position()
			
			if target_position.distance_to(current_position) >= min_wander_distance:
				print("New target set to: ", target_position)
				return
		
		attempts += 1
	
	print("Failed to find a suitable new target after 10 attempts.")

func _on_body_entered(body):
	if body.is_in_group("player"):
		dialogue_box.show()
		dialogue_box.set_text("Hello! I have a mission for you.")

func _on_body_exited(body):
	if body.is_in_group("player"):
		dialogue_box.hide()

func receive_item(item_id):
	if item_id == target_item_id:
		print("Thank you for delivering the item!")
		# Handle mission completion logic
