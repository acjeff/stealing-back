# LargeItem.gd
extends RigidBody3D

@export var weight: float = 20.0
@export var value: float = 50.0

var dragging: bool = false
var player: CharacterBody3D = null  # Reference to the player

func set_dragging(state: bool, player_ref: CharacterBody3D):
	dragging = state
	player = player_ref if state else null
