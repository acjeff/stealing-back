# PickupPromptUI.gd
extends CanvasLayer

@onready var prompt_label = $Label

func show_prompt():
	prompt_label.text = "Press 'F' to pick up the item"
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false
