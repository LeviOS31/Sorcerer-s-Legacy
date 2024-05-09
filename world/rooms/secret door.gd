extends Area2D

var hit = false
var anim_finished = false
var player_in = false
var health = 1000000

var active = false # for global script
signal entered(object)
signal exited(object)

func _input(event):
	if event.is_action_pressed("action") && player_in && anim_finished:
		enter_secret_room()
		active = false

func _on_hurtbox_hit(enemy):
	if !hit:
		hit = true
		yield(get_tree().create_timer(0.3), "timeout")
		$AnimationPlayer.play("burn")
		yield($AnimationPlayer, "animation_finished")
		anim_finished = true
		active = true

func _on_secret_door_body_entered(body):
	if body.name == "player":
		emit_signal("entered", self)
		player_in = true

func _on_secret_door_body_exited(body):
	emit_signal("exited", self)
	player_in = false

func enter_secret_room():
	print("enter")

