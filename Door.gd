# Door.gd
extends Node3D

@export var open_angle: float = 90.0  # The angle the door will open to in degrees
@export var open_speed: float = 2.0  # The speed of opening and closing
var is_open: bool = false
var target_angle: float = 0.0
var current_angle: float = 0.0
var player_in_proximity: bool = false

@onready var door_offset = $DoorOffset
@onready var proximity_area = $ProximityArea

func _ready():
	# Connect signals for proximity detection
	proximity_area.body_entered.connect(_on_proximity_area_body_entered)
	proximity_area.body_exited.connect(_on_proximity_area_body_exited)

func _process(delta):
	# Smoothly interpolate to the target angle
	current_angle = lerp(current_angle, target_angle, delta * open_speed)
	door_offset.rotation_degrees.y = current_angle

func _input(event):
	if event.is_action_pressed("interact") and player_in_proximity:
		toggle_door()

func toggle_door():
	is_open = not is_open
	target_angle = open_angle if is_open else 0.0

func _on_proximity_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_proximity = true

func _on_proximity_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_proximity = false
