extends Area2D

var activate = false

var active = false # for global script
signal entered(object)
signal exited(object)

func _input(event):
	if event.is_action_pressed("action"):
		if activate:
			Playerstats.dubblejump = true
			emit_signal("exited", self)
			active = false
			$effect.queue_free()
			$Fearther.queue_free()
			var package = load("res://general purpose/UI/aquired_item.tscn");
			var instance = package.instance()
			get_tree().get_nodes_in_group("canvas")[0].add_child(instance)
			instance.aquire_powerup("double_jump")
			

func _on_altar_body_entered(body):
	if !Playerstats.dubblejump and body.name == "player":
		activate = true
		active = true
		emit_signal("entered", self)


func _on_altar_body_exited(body):
	emit_signal("exited", self)
	activate = false
