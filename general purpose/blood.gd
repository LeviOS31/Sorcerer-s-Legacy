extends Node2D

onready var emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if emitting:
		$Particles2D.emitting = true
		


func _on_Timer_timeout():
	queue_free()
