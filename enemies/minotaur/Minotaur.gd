extends KinematicBody2D

enum{
	IDLE
	ATTACK
	CHARGE
	CONCUSSED
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
onready var died = false
onready var is_attacking = false
onready var charge_hitbox = $Sprite/hitbox/CollisionShape2D
var player
var previous_direction = null

func _ready():
	pass

func _process(delta):
	if health <= 0:
		death()
		

func _physics_process(delta):
	if !Global.is_in_dialogue:
		if !hit && !died:
			match state:
				IDLE:
					velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
					animation.play("idle")
				ATTACK:
					if !is_attacking:
						var distance = global_position.distance_to(player.global_position)
						if distance <= 34:
							velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
							Attack()
						elif distance > 150:
							state = IDLE
						else:
							animation.play("run")
							velocity = velocity.move_toward(direction * speed, ACCL * delta)
				CHARGE:
					animation.play("run")
					velocity = velocity.move_toward(direction * chargespeed, chargeACCL * delta)
					charge_hitbox.disabled = false
				CONCUSSED:
					velocity = Vector2.ZERO
					animation.play("concussed")
					
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
		
func Attack():
	is_attacking = true
	animation.play("attack")
	yield(animation, "animation_finished")
	is_attacking = false
	

func _on_hurtbox_hit(enemy):
	if !died:
		animation.play("hit")
		hit = true
		var knockbackdirection = (global_position - enemy.global_position).normalized()
		velocity = velocity + (knockbackdirection * Global.knockbackspeed / 2)

func death():
	if !died:
		died = true
		#pause_mode = Node.PAUSE_MODE_STOP
		animation.play("death")
		yield(animation, "animation_finished")
		queue_free()

func Charge():
	player = get_tree().get_nodes_in_group("player")[0]
	if player.global_position.x > global_position.x:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	state = CHARGE


func _on_chargestop_body_entered(body):
	print(body.name)
	if body.name == "TileMap":
		charge_hitbox.disabled = true
		state = CONCUSSED
	else:
		charge_hitbox.disabled = true
		state = ATTACK


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "concussed":
		state = ATTACK
