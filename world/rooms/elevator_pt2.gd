extends Area2D

var player_in = false

var active = true # for global script
signal entered(object)
signal exited(object)

func _input(event):
	if player_in && event.is_action_pressed("action"):
		emit_signal("exited", self)
		active = false

func _on_Area2D_body_entered(body):
	if body.name == "player":
		player_in = true
		emit_signal("entered", self)

func _on_Area2D_body_exited(body):
	player_in = false
	if body.name == "player":
		emit_signal("exited", self)
