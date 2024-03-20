extends KinematicBody2D

export (int) var Walk = 120
export (int) var Jump_speed = -270
export (int) var Gravity = 1000
export (int) var Friction = 1900
export var max_health = 4

var health
var velocity = Vector2.ZERO
var jump_pressed_time = 0.0
var max_jump_time = 0.20
var is_jumping = false
export var is_attacking = false

onready var panimation = $AnimationPlayer
onready var tanimation = $AnimationTree
onready var anistate = tanimation.get("parameters/playback")

func _ready():
	health = max_health

func _physics_process(delta):
	move(delta)
	

func _input(event):
	if event.is_action("attack"):
		attack();

func move(delta):
	#if(!is_attacking):
	var x = 0
	
	x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	
	if x != 0:
		if x < 0:
			$playersprite.scale = Vector2(-1,1)
		elif x > 0:
			$playersprite.scale = Vector2(1,1)
		velocity.x = x * Walk
		
	else:
		velocity.x = move_toward(velocity.x, 0, Friction * delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		jump_pressed_time = 0.0
	if Input.is_action_pressed("jump") and is_jumping and jump_pressed_time < max_jump_time:
		velocity.y = Jump_speed
		jump_pressed_time += delta
	
	
	if velocity.y < 0:
		anistate.travel("jump")
	elif velocity.y > 0:
		anistate.travel("fall")
	elif velocity.x != 0:
		anistate.travel("run")
	else:
		anistate.travel("idle")
	
	#if is_attacking:
	#	velocity.x = move_toward(velocity.x, 0, delta)
		
	velocity.y += Gravity * delta
	velocity.y = clamp(velocity.y, -100000, 1500)
	velocity = move_and_slide(velocity, Vector2.UP, true)

func attack():
	anistate.travel("attack")
	is_attacking = true
	yield(panimation, "animation_finished")
	is_attacking = false

func attack_finished():
	is_attacking = false
