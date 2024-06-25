extends Spatial


var launchspeed
var launchangle
var Gravity = -12
var arrow = preload("res://arrow_test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_key_pressed(KEY_P):
		fire_arrow()

func fire_arrow():
	if calculatelaunch(translation, Global.target, Gravity):
		pass
		#var initalVelocity = CalculateInitialVelocity(translation, Global.target, launchangle, launchspeed)
		#var predictedlandingposition = predictlandingposition(translation, initalVelocity, Vector3(0,Gravity,0))
	var arrow_instance = arrow.instance()
	add_child(arrow_instance)
	arrow_instance.fire(launchspeed, launchangle)

func calculatelaunch (startPosition: Vector3, targetPosition: Vector3, gravity: float):
	var displacement = targetPosition - startPosition
	
	var xzDistance = Vector3(displacement.x, 0, displacement.z).length()
	var y = displacement.y

	var gravityABS = abs(gravity)
	
	var term1 = gravityABS * (xzDistance * xzDistance)
	var term2 = 2 * y * gravityABS
	var speedSQRD = sqrt(term1 + term2)

	if speedSQRD < 1:
		return false
	
	var speed = sqrt(speedSQRD)
	launchspeed = speed
	
	speed = speed * 2
	print(y)
	print(speed)
	print(gravityABS)
	print(xzDistance)
	
	var angleradians = atan((speed * speed + sqrt(speed * speed * speed * speed - gravityABS * (gravityABS * xzDistance * xzDistance + 2 * y * speed * speed))) / (gravityABS * xzDistance))
	launchangle = rad2deg(angleradians)
	return true

func CalculateInitialVelocity (startPosition : Vector3, targetPosition : Vector3, launchangle : float, launchspeed : float):
	var direction = (targetPosition - startPosition).normalized()
	var rotate_axis = Vector3.UP.cross(direction).normalized()
	var rotate_angle = deg2rad(launchangle)
	var rotate_quat = Quat()
	rotate_quat.set_axis_angle(rotate_axis, rotate_angle)

	# Check and normalize quaternion if necessary
	if !rotate_quat.is_normalized():
		rotate_quat.normalize()

	var initial_velocity = rotate_quat.xform(direction) * launchspeed
	return initial_velocity

func cross_product(a: Vector3, b: Vector3) -> Vector3:
	return Vector3(
		a.y * b.z - a.z * b.y,
		a.z * b.x - a.x * b.z,
		a.x * b.y - a.y * b.x
	)

func predictlandingposition(startPosition : Vector3, initialVelocity : Vector3, gravity :  Vector3):
	var flighttime = (2 * initialVelocity.y) / -gravity.y
	var landingposition = startPosition + Vector3(initialVelocity.x * flighttime, 0, initialVelocity.z * flighttime)
	print(landingposition)
