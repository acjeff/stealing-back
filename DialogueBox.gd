extends Control

@onready var label = $Label

func set_text(new_text):
	label.text = new_text
