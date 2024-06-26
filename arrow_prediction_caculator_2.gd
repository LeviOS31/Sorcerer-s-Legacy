extends Spatial

var launchspeed
var launchangle
var Gravity = -9.8
var max_range = 100
var arrow = preload("res://arrow_test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_key_pressed(KEY_P):
		fire_arrow()

func fire_arrow():
	Calculatelaunch(translation, Global.target, Gravity)
	
	var arrow_instance = arrow.instance()
	add_child(arrow_instance)
	arrow_instance.fire(launchspeed, launchangle)

func Calculatelaunch(startPos, targetPos, gravity):
	pass
