extends Node2D

var Dialogue_resource = preload("res://Dialogue/first_boss_fight_start.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../enemies/crystal_mauler".connect("death", self, "bossdeath")

func _on_Trigger_body_entered(body):
	if body.name == "player" && !Global.cutscene_2_seen:
		show_dialogue("first_boss_fight_start",Dialogue_resource)

func show_dialogue(title:String, resource: DialogueResource):
	var dialogue_lines = yield(DialogueManager.get_next_dialogue_line(title, resource), "completed")
	if dialogue_lines != null:
		var balloon = preload("res://Dialogue/Dialogue_balloon/balloon.tscn").instance()
		balloon.dialogue_line = dialogue_lines
		get_tree().current_scene.add_child(balloon)
		show_dialogue(yield(balloon, "actioned"), Dialogue_resource)
	else:
		get_tree().paused = false

func bossdeath():
	var scene = load("res://general purpose/UI/Boss_slain.tscn")
	var instance = scene.instance()
	get_tree().get_nodes_in_group("canvas")[0].add_child(instance)
	instance.Boss_slain()
	$AnimationPlayer.play("finish");
