extends Node2D


func _process(delta):
	if Playerstats.Crystal:
		if $crystal_spot.animation != "New Anim":
			$crystal_spot.play("New Anim")
