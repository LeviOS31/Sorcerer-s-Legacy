extends Area2D

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_hurtbox_area_entered(area):
	if area.name == "hitbox": 
		print(area)
		emit_signal("hit")
