extends Camera

# Reference to the RayCast node
onready var raycast = preload("res://RayCast.tscn").instance()

# Reference to the target node (ensure you add this node to your scene)
onready var target = preload("res://target.tscn").instance()

var from
var to

# How far the ray should extend
export var ray_length = 100000

func _ready():
	# Ensure the RayCast is enabled
	raycast.enabled = true
	# Add the target to the scene but hide it initially
	
func _input(event):
	
	#if from:
	#	DebugDraw.draw_line(from, to, Color(1, 0, 0))
	if raycast.get_parent() == null:
		get_tree().get_root().add_child(raycast)
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		update_target_position()
	
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		get_tree().get_root().add_child(target)
		target.visible = false

func update_target_position():
	# Cast a ray from the camera to the mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	raycast.translation = get_parent().translation
	raycast.cast_to = project_ray_normal(mouse_pos) * ray_length
	raycast.force_raycast_update()

	if raycast.is_colliding():
		#print(raycast.get_collision_point())
		var collision_point = raycast.get_collision_point()
		target.translation.x = collision_point.x
		target.translation.y = collision_point.y
		target.translation.z = $"../../arrowshootstart/hollow beam".translation.z
		target.visible = true
		Global.target = target.translation
	else:
		target.visible = false
	
	#from = global_transform.origin
	#to = from + raycast.cast_to
	
	
