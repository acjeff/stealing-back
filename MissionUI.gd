extends Control

var mission_list: Array = [
	{
		"id": 1,
		"name": "Gold Watch",
		"description": "Find and return the stolen Gold Watch to the jeweler.",
		"item_ids": [1],
		"npc_id": 1,
		"reward": 100,
		"status": 'available'
	},
	{
		"id": 2,
		"name": "Secret Blueprint",
		"description": "Deliver the secret document to the agent at the safe house.",
		"item_ids": [2],
		"npc_id": 2,
		"reward": 50,
		"status": 'active'
	},
	{
		"id": 3,
		"name": "Banana",
		"description": "Get the Monkey a banana.",
		"item_ids": [3],
		"npc_id": 3,
		"reward": 1,
		"status": 'active'
	}
]

var current_mission_index = 0
var status_list_viewing = "active"
var app_list_viewing = "missions"

@onready var name_label = $"Panel/MissionTabBar/MissionNameLabel"
@onready var description_label = $"Panel/MissionTabBar/MissionDescriptionLabel"
@onready var next_mission_button = $"Panel/MissionTabBar/Missions/NextMissionButton"
@onready var previous_mission_button = $"Panel/MissionTabBar/Missions/PreviousMissionButton"
@onready var accept_mission_button = $"Panel/MissionTabBar/Missions/AcceptMissionButton"
@onready var close_button = $"Panel/Header/CloseButton"
@onready var abandon_mission_button = $"Panel/MissionTabBar/Missions/AbandonMissionButton"
@onready var tabs = $Panel/MissionTabBar
@onready var appTabs = $Panel/AppTabBar

func _ready():
	update_ui()
	visible = false
	next_mission_button.connect("pressed", Callable(self, "_on_next_mission_pressed"))
	previous_mission_button.connect("pressed", Callable(self, "_on_previous_mission_pressed"))
	accept_mission_button.connect("pressed", Callable(self, "_on_accept_mission_pressed"))
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	abandon_mission_button.connect("pressed", Callable(self, "_on_abandon_mission_pressed"))
	tabs.connect("tab_changed", Callable(self, "_on_tab_changed"))
	appTabs.connect("tab_changed", Callable(self, "_on_app_tab_changed"))
	
func _on_next_mission_pressed():
	var missions = _get_new_missions()
	print("Next mission button pressed")
	current_mission_index = (current_mission_index + 1) % missions.size()
	update_ui()

func _on_previous_mission_pressed():
	var missions = _get_new_missions()
	print("Previous mission button pressed")
	current_mission_index = (current_mission_index - 1 + missions.size()) % missions.size()
	update_ui()

func _on_accept_mission_pressed():
	print("Accept mission button pressed")
	_get_new_missions()[current_mission_index].status = 'active'
	if current_mission_index > 0:
		current_mission_index -= 1
	update_ui()

func _on_abandon_mission_pressed():
	print("Accept mission button pressed")
	_get_new_missions()[current_mission_index].status = 'available'
	if current_mission_index > 0:
		current_mission_index -= 1
	update_ui()

func _on_close_button_pressed():
	print("Close button pressed")
	hide()

func _on_tab_changed(tab_index: int):
	if tab_index == 0:
		status_list_viewing = 'available'
	else:
		status_list_viewing = 'active'
	update_ui()

func _on_app_tab_changed(tab_index: int):
	if tab_index == 0:
		app_list_viewing = 'missions'
	else:
		app_list_viewing = 'banking'
	update_ui()
	

func _get_new_missions(override = null):
	var _status = status_list_viewing
	if override:
		_status = override
		print(_status)
	return mission_list.filter((func(element): return element.status == _status))

func render_banking_ui():
	pass

func render_mission_ui():
	var missions = _get_new_missions()
	if missions.size() > 0:	
		var mission = missions[current_mission_index]
		name_label.text = mission["name"]
		description_label.text = mission["description"]
		if status_list_viewing == 'available':
			$"Panel/MissionTabBar/Missions/AcceptMissionButton".show()
			$"Panel/MissionTabBar/Missions/AbandonMissionButton".hide()
		else:
			$"Panel/MissionTabBar/Missions/AbandonMissionButton".show()
			$"Panel/MissionTabBar/Missions/AcceptMissionButton".hide()
		if missions.size() > 1:
			$"Panel/MissionTabBar/Missions/NextMissionButton".show()
			$"Panel/MissionTabBar/Missions/PreviousMissionButton".show()
		else:
			$"Panel/MissionTabBar/Missions/NextMissionButton".hide()
			$"Panel/MissionTabBar/Missions/PreviousMissionButton".hide()
	else:
		$"Panel/MissionTabBar/Missions/AcceptMissionButton".hide()
		$"Panel/MissionTabBar/Missions/AbandonMissionButton".hide()
		$"Panel/MissionTabBar/Missions/NextMissionButton".hide()
		$"Panel/MissionTabBar/Missions/PreviousMissionButton".hide()
		if status_list_viewing == 'available':
			name_label.text = "No missions available"
			description_label.text = ""
		else:
			name_label.text = "No active missions"
			description_label.text = ""

func update_ui():
	if app_list_viewing == 'missions':
		tabs.show()
		render_mission_ui()
	elif app_list_viewing == 'banking':
		tabs.hide()
		render_mission_ui()
	tabs.set_tab_title(0, "    Available " + "(" + str(_get_new_missions('available').size()) + ")    ")
	tabs.set_tab_title(1, "    Active " + "(" + str(_get_new_missions('active').size()) + ")    ")
