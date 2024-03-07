extends KinematicBody2D

export (int) var Walk = 120
export (int) var Jump_speed = -200
export (int) var Gravity = 1000
export (int) var Friction = 10

var velocity = Vector2.ZERO
var jump_pressed_time = 0.0
var max_jump_time = 0.15
var is_jumping = false
var running = false
var facing_right = true

onready var panimation = $AnimationPlayer

func Move():
	velocity.x = 0
	
	if facing_right == true:
		$playersprite.scale.x = 1
	else:
		$playersprite.scale.x = -1
	
	if Input.is_action_pressed("walk_right"):
		print("right")
		facing_right = true
		velocity.x += Walk
	elif Input.is_action_pressed("walk_left"):
		print("left")
		facing_right = false
		velocity.x -= Walk
	if Input.is_action_pressed("run"):
		running = true
		velocity.x *= 1.7
	else:
		running = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		jump_pressed_time = 0.0

	if Input.is_action_pressed("jump") and is_jumping and jump_pressed_time < max_jump_time:
		velocity.y = Jump_speed
		jump_pressed_time += get_process_delta_time()
	else:
		is_jumping = false
		
	if velocity.x == 0 && is_on_floor():
		panimation.play("idle_right")
	else:
		if running:
			panimation.play("run_right")
		else:
			panimation.play("walk_right")
	if velocity.y < 0 && !is_on_floor():
		panimation.play("jump_start_right")
	if velocity.y > 0 && !is_on_floor():
		panimation.play("fall_right")

func _physics_process(delta):
	Move()
	velocity.y += Gravity * delta
	velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	velocity = move_and_slide(velocity, Vector2.UP, true)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		Attack()
		

func Attack():
	panimation.play("attack_right")
