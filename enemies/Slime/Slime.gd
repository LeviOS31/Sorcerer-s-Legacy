extends KinematicBody2D

enum {
	WANDER
	IDLE
}

export (int) var health = 2
export (int) var speed = 50
export (int) var ACCL = 200
export (int) var Friction = 4000
export (int) var Gravity = 1000

onready var velocity = Vector2.ZERO
onready var state = WANDER
onready var direction = Vector2.LEFT
onready var animation = $AnimationPlayer
onready var sprite = $Sprite
onready var hit = false
onready var death = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if health <= 0:
		death()

func _physics_process(delta):
	if !hit && !death:
		match state:
			WANDER:
				velocity = velocity.move_toward(direction * speed, ACCL * delta)
				animation.play("move")
			IDLE:
				velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
				animation.play("idle")
				
		velocity.y += Gravity
		velocity = move_and_slide(velocity)
		if velocity.x != 0:
			if velocity.x < 0:
				$Sprite.scale = Vector2(1,1)
			elif velocity.x > 0:
				$Sprite.scale = Vector2(-1,1)

func _on_hurtbox_hit(enemy):
	if !death:
		animation.play("hit")
		hit = true
		var knockbackdirection = (global_position - enemy.global_position).normalized()
		velocity = velocity + (knockbackdirection * Global.knockbackspeed / 2)

func _on_left_body_exited(_body):
	direction = Vector2.RIGHT
	$Timer.start(0.5)
	state = IDLE

func _on_right_body_exited(_body):
	direction = Vector2.LEFT
	$Timer.start(0.5)
	state = IDLE

func _on_Timer_timeout():
	state = WANDER

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		hit = false

func death():
	if !death:
		death = true
		#pause_mode = Node.PAUSE_MODE_STOP
		animation.play("die")
		yield(animation, "animation_finished")
		queue_free()
