extends Node2D

onready var entrances

func _ready():
	entrances = get_node("entrances").get_children()
	

func get_entrance(prevroomnum):
	for entrance in entrances:
		if entrance.name == prevroomnum:
			return entrance.global_position


