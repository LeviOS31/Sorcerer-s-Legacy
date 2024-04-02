extends Control

export (NodePath) onready var player = get_node(player)
onready var heart = $fullhealth
onready var hearts = []

func _ready():
	for x in (Playerstats.max_health):
		var duplicated = heart.duplicate()
		duplicated.visible = true
		hearts.append(duplicated)
		$HBoxContainer.add_child(duplicated)

func _process(delta):
	if player.health < hearts.size():
		hearts.back().queue_free()
		hearts.erase(hearts.back())
		
	if player.health > hearts.size():
		var duplicated = heart.duplicate()
		duplicated.visible = true
		hearts.append(duplicated)
		$HBoxContainer.add_child(duplicated)
