extends Spatial


var launchspeed
var launchangle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func caclculatelaunch (startPosition: Vector3, targetPosition: Vector3, gravity: float):
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

	var angleradians = atan((speed * speed + sqrt(speed * speed * speed * speed - gravityABS * (gravityABS * xzDistance * xzDistance + 2 * y * speed * speed))) / (gravityABS * xzDistance))
	launchangle = rad2deg(angleradians)
	return true

func CalculateInitialVelocity (startPosition : Vector3, targetPosition : Vector3, launchangle : float, launchspeed : float):
	var direction = (targetPosition - startPosition).normalized()
	var rotation = 