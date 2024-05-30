extends Node2D

var outside:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_transition_inside_body_entered(body):
	if outside:
		get_tree().get_nodes_in_group("Darkness_animator")[0].play("inside")
		outside = false


func _on_transition_outside_body_entered(body):
	if !outside:
		get_tree().get_nodes_in_group("Darkness_animator")[0].play("outside")
		outside = true
