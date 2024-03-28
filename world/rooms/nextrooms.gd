extends Node

export (NodePath) onready var world = get_node(world).get_parent()

func _ready():
	pass # Replace with function body.

func _on_nextroom_body_entered(body, extra_arg_0):
	if body.name == "player":
		world.nextroom = extra_arg_0
		world.transition()
