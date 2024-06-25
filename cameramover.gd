extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14

var velocity = Vector3.ZERO

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	if Input.is_action_pressed("move_down"):
		direction.y -= 1
	if Input.is_action_pressed("turn_left"):
		rotation.y += 0.05
	if Input.is_action_pressed("turn_right"):
		rotation.y -= 0.05
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction = global_transform.basis.xform(direction)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y = direction.y * speed
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)
	#$Pivot.look_at(translation + direction, Vector3.UP)
