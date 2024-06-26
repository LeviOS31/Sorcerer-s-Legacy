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
	if calculatelaunch(translation, Global.target, Gravity):
		pass
	var arrow_instance = arrow.instance()
	add_child(arrow_instance)
	arrow_instance.fire(launchspeed, launchangle)

func calculatelaunch (startPosition: Vector3, targetPosition: Vector3, gravity: float):
	
	var displacement = targetPosition - startPosition
	
	var xzDistance = Vector3(displacement.x, 0, displacement.z).length()
	
	var maxspeed = sqrt(10 * 9.8 / sin(2 * 0.785))
	print(maxspeed)
	
	var y = displacement.y

	var gravityABS = abs(gravity)
	
	var term1 = gravityABS * (xzDistance * xzDistance)
	var term2 = 2 * y * gravityABS
	var speedSQRD = sqrt(term1 + term2)

	if speedSQRD < 1:
		return false
	
	var speed = sqrt(speedSQRD)
	print(speed)
	speed = clamp(speed, 0, maxspeed)
	
	launchspeed = speed
	
	speed = speed * 2
	print(xzDistance)
	
	var angleradians = atan((speed * speed + sqrt(speed * speed * speed * speed - gravityABS * (gravityABS * xzDistance * xzDistance + 2 * y * speed * speed))) / (gravityABS * xzDistance))
	launchangle = rad2deg(angleradians)
	return true
