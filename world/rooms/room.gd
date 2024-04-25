extends Node2D

onready var entrances
#onready var player

func _ready():
	entrances = get_node("entrances").get_children()
#	player = get_parent().get_node("player") 

func get_entrance(prevroomnum):
	for entrance in entrances:
		if entrance.name == prevroomnum:
			return entrance.global_position

#func _process(delta):
#	if get_node_or_null("platforms") != null:
#		if player.velocity.y < 100 && !player.is_on_floor():
#			get_node("platforms").set_collision_layer_bit(0, false)
#			get_node("platforms").set_collision_layer_bit(11, false)
#			get_node("platforms").set_collision_mask_bit(0, false)
#		else:
#			get_node("platforms").set_collision_layer_bit(0, true)
#			get_node("platforms").set_collision_layer_bit(11, true)
#			get_node("platforms").set_collision_mask_bit(0, false)

