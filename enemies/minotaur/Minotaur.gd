extends KinematicBody2D

enum{
	IDLE
	ATTACK
	CHARGE
}

export (int) var health = 4
export (int) var speed = 70
export (int) var chargespeed = 200
export (int) var chargeACCL = 300
export (int) var ACCL = 100
export (int) var Friction = 2000
export (int) var chargeFriction = 200
export (int) var Gravity = 1000

onready var velocity = Vector2.ZERO
onready var state = IDLE
onready var direction = Vector2.LEFT
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var hit = false
onready var death = false
onready var is_attacking = false
var player
var previous_direction = null

func _ready():
	pass

func _process(delta):
	if health <= 0:
		death()
		

func _physics_process(delta):
	if !Global.is_in_dialogue:
		if !hit && ! death:
			match state:
				IDLE:
					previous_direction = null
					velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
					animation.play("idle")
				ATTACK:
					previous_direction = null
					pass
				CHARGE:
					var direction = Vector2.ZERO
					
					if player.global_position.x > global_position.x:
						direction = Vector2.RIGHT
					else:
						direction = Vector2.LEFT
						
					animation.play("run")
					print(direction)
					if direction == previous_direction || previous_direction == null:
						velocity = velocity.move_toward(direction * chargespeed, chargeACCL * delta)
						previous_direction = direction
					else:
						state = IDLE
			velocity.y += Gravity
			velocity = move_and_slide(velocity)
			if velocity.x != 0:
				if velocity.x > 0:
					$Sprite.scale = Vector2(1,1)
				elif velocity.x < 0:
					$Sprite.scale = Vector2(-1,1)
	else:
		velocity = move_and_slide(Vector2.ZERO)
		animation.play("idle")

func _on_hurtbox_hit(enemy):
	if !death:
		animation.play("hit")
		hit = true
		var knockbackdirection = (global_position - enemy.global_position).normalized()
		velocity = velocity + (knockbackdirection * Global.knockbackspeed / 2)

func death():
	if !death:
		death = true
		#pause_mode = Node.PAUSE_MODE_STOP
		animation.play("death")
		yield(animation, "animation_finished")
		queue_free()
	

func Charge():
	player = get_tree().get_nodes_in_group("player")[0]
	state = CHARGE
	
