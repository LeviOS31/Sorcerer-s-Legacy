extends StaticBody2D
 
onready var playeronelevator = null

func _input(event):
	if event.is_action_pressed("action"):
		if playeronelevator != null:
			$AnimationPlayer.play("up")

func _on_Area2D_body_entered(body):
	if body.name == "player":
		playeronelevator = body

func _on_Area2D_body_exited(body):
	if body.name == "player":
		playeronelevator = null
