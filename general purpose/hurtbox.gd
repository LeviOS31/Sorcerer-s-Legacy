extends Area2D

signal hit(enemy)

export (NodePath) onready var parent = get_node(parent)
#onready var bleedpackage = load("res://general purpose/blood.tscn")
#onready var bleed

var timer
var area

func _on_hurtbox_area_entered(area):
#	bleed = bleedpackage.instance()
	if area.name == "hitbox": 
#		bleed.global_position = get_parent().global_position
#		get_tree().get_root().add_child(bleed)
#		bleed.emitting = true
		if area.attacktype == "normal":
			parent.health = parent.health - area.damage
			emit_signal("hit", area)
		if area.attacktype == "ongoing":
			parent.health = parent.health - area.damage
			emit_signal("hit", area)
			self.area = area
			timer = Timer.new()
			timer.wait_time = area.damage_interval
			timer.one_shot = false
			timer.connect("timeout", self, "take_damage_overtime")
			add_child(timer)
			timer.start()
			print("started damage")
		if area.attacktype == "spikes":
			parent.health = parent.health - area.damage
			var dummyarea = Node2D.new()
			dummyarea.global_position = parent.global_position
			dummyarea.global_position.y += 200
			emit_signal("hit", dummyarea)

func _on_hurtbox_area_exited(area):
	if area.name == "hitbox":
		if area.attacktype == "ongoing":
			timer.queue_free()
			print("ended damage")

func take_damage_overtime():
	var areas = get_overlapping_areas()
	for area2 in areas:
		if area2.name == "hitbox":
			parent.health = parent.health - area.damage
			emit_signal("hit", area)
	if areas.size() == 0:
		if is_instance_valid(timer):
			timer.queue_free()
			print("ended damage")
