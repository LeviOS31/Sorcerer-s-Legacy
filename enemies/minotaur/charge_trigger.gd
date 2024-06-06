extends Area2D

export (NodePath) onready var minotaur = get_node(minotaur)

func _on_charge_trigger_body_entered(body):
	if body.name == "player":
		minotaur.Charge()
