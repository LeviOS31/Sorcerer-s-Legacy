extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Dialogue_resource = preload("res://Dialogue/first encounter boss.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_trigger_body_entered(body):
	if body.name == "player":
		DialogueManager.show_example_dialogue_balloon("first_boss_encounter", Dialogue_resource)
		#var dailogue_line = yield(DialogueManager.get_next_dialogue_line("first_boss_encounter", Dialogue_resource), "completed")
