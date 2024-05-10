extends Node

var knockbackspeed = 500
var is_in_dialogue = false
var actionable_objects;

var input = preload("res://general purpose/input_action.tscn")
var instance

### CUTSCENE'S ###
var cutscene_1_seen = false

func _ready():
	actionable_objects = get_tree().get_nodes_in_group("action")
	for object in actionable_objects:
		object.connect("entered", self, "entered_actionable_object")
		object.connect("exited", self, "exited_actionable_object")


func entered_actionable_object(object):
	var player = get_tree().get_nodes_in_group("player")[0]
	if object.active:
		instance = input.instance()
		player.add_child(instance)
		instance.position.y -= 20

func exited_actionable_object(object):
	if object.active:
		if is_instance_valid(instance):
			instance.queue_free()
