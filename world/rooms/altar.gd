extends Area2D
var activate = false

func _input(event):
	if event.is_action_pressed("action"):
		if activate:
			Playerstats.dubblejump = true
			$effect.queue_free()
			$Fearther.queue_free()

func _on_altar_body_entered(body):
	if !Playerstats.dubblejump and body.name == "player":
		activate = true
