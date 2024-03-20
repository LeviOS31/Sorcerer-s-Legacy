extends Area2D

signal hit

export (NodePath) onready var parent = get_node(parent)
#onready var bleedpackage = load("res://general purpose/blood.tscn")
#onready var bleed

func _on_hurtbox_area_entered(area):
#	bleed = bleedpackage.instance()
	if area.name == "hitbox": 
		print(area)
#		bleed.global_position = get_parent().global_position
#		get_tree().get_root().add_child(bleed)
#		bleed.emitting = true
		print(parent.health)
		parent.health = parent.health - area.damage
		print(parent.health)
		emit_signal("hit")
