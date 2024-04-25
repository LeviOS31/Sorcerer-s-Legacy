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
	if body.name == "player" && !Global.cutscene_1_seen:
		show_dialogue("first_boss_encounter",Dialogue_resource)
		

func show_dialogue(title:String, resource: DialogueResource):
	var dialogue_lines = yield(DialogueManager.get_next_dialogue_line(title, resource), "completed")
	if dialogue_lines != null:
		var balloon = preload("res://Dialogue/Dialogue_balloon/balloon.tscn").instance()
		balloon.dialogue_line = dialogue_lines
		get_tree().current_scene.add_child(balloon)
		show_dialogue(yield(balloon, "actioned"), Dialogue_resource)
	else:
		get_tree().paused = false
