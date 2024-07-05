extends Node

@export var json_file_path: String = "res://Missions.json"
var mission_list: Array = []

func _ready():
	load_missions()

func load_missions():
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json_instance = JSON.new()
		var result = json_instance.parse(json_text)
		if result == OK:
			mission_list = json_instance.data
			print("Missions loaded: ", mission_list)
		else:
			print("Failed to parse JSON: ", json_instance.error_string)
		file.close()
	else:
		print("Failed to load missions from ", json_file_path)
