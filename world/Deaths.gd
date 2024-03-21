extends Node

func _on_area2d_body_entered(body, extra_arg_0):
	body.global_position = get_node(extra_arg_0).get_child(1).global_position
