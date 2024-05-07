extends StaticBody2D


func _process(delta):
	if Input.is_action_pressed("Down"):
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
