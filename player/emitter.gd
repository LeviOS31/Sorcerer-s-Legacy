extends Node2D


func start():
	$Particles2D_dubblejump.emitting = true
	$Timer.start(1)


func _on_Timer_timeout():
	queue_free()
