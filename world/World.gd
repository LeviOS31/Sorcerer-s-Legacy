extends Node2D


var currentroom = "room7"
var nextroom = ""
var previousroom = ""
export (NodePath) onready var camera = get_node(camera)
export (NodePath) onready var player = get_node(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	var currentroomnode = get_node(currentroom)
	for room in get_tree().get_nodes_in_group("room"):
		if room.name != currentroom:
			room.pause_mode = Node.PAUSE_MODE_STOP
	camera.limit_left = currentroomnode.get_node("cameracontraints/topleft").global_position.x
	camera.limit_top = currentroomnode.get_node("cameracontraints/topleft").global_position.y
	camera.limit_right = currentroomnode.get_node("cameracontraints/bottomright").global_position.x
	camera.limit_bottom = currentroomnode.get_node("cameracontraints/bottomright").global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func transition():
	if nextroom != "":
		get_node(currentroom).pause_mode = Node.PAUSE_MODE_STOP
		previousroom = currentroom
		currentroom = nextroom
		
		player.global_position = get_node(currentroom).get_entrance(previousroom)
		
		#camera.smoothing_speed = 2
		
		camera.limit_left = -10000000
		camera.limit_right = 10000000
		camera.limit_top = -10000000
		camera.limit_bottom = 10000000
		
		#camera.smoothing_speed = 5
		
		var currentroomnode = get_node(currentroom)
		
		camera.limit_left = currentroomnode.get_node("cameracontraints/topleft").global_position.x
		camera.limit_top = currentroomnode.get_node("cameracontraints/topleft").global_position.y
		camera.limit_right = currentroomnode.get_node("cameracontraints/bottomright").global_position.x
		camera.limit_bottom = currentroomnode.get_node("cameracontraints/bottomright").global_position.y
		

func playscene(scene):
	get_node(currentroom).get_node("scene/AnimationPlayer").play(scene)
