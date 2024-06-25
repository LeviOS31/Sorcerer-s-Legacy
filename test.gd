extends KinematicBody

var startvelocity = Vector3(-13.2, 0, 0)
var velocity = Vector3.ZERO
var Gravity = -9.8
var collided = false
var fired = false
var GTB

func _ready():
	startvelocity = global_transform.basis * startvelocity
	GTB = global_transform.basis
	velocity = startvelocity

func fire(launchspeed, launchangle):
	rotation.z = -1 * launchangle
	velocity = global_transform.basis * Vector3((2 * launchspeed),0,0)
	fired = true

func _process(delta):
	if !collided && fired:
		velocity.y += Gravity * delta
		move_and_slide(velocity)

		if velocity.length_squared() > 0:
			var direction = velocity.normalized()
			
			# Preserve current X and Y rotation
			var current_basis = global_transform.basis
			var current_x_axis = current_basis.x.normalized()
			var current_y_axis = current_basis.y.normalized()
			
			# Calculate new Z axis (direction of velocity)
			var new_z_axis = direction
			
			# Ensure x and y axes are perpendicular to the new z axis
			var new_x_axis = new_z_axis.cross(current_y_axis).normalized()
			var new_y_axis = new_x_axis.cross(new_z_axis).normalized()
			
			# Create a new basis with preserved X and Y rotation and updated Z rotation
			var new_basis = Basis(new_x_axis, new_y_axis, new_z_axis)
			global_transform.basis = new_basis
	else:
		move_and_collide(Vector3.ZERO)

func _on_Area_area_entered(area):
	print("collision")
	collided = true
