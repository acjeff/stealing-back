extends Node

var npcs = []

func _ready():
	npcs = get_tree().get_nodes_in_group("NPCs")

func find_npc_by_id(npc_id):
	for npc in npcs:
		if npc.npc_id == npc_id:
			return npc
	return null
