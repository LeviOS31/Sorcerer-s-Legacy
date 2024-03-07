extends KinematicBody2D

export (int) var Walk = 200
export (int) var Jump_speed = -250
export (int) var Gravity = 1000
export (int) var Friction = 1900

var velocity = Vector2.ZERO
var jump_pressed_time = 0.0
var max_jump_time = 0.20
var is_jumping = false

onready var panimation = $AnimationPlayer
onready var tanimation = $AnimationTree
onready var anistate = tanimation.get("parameters/playback")

func _ready():
	pass

func _physics_process(delta):
	move(delta)
	

func move(delta):
	var x = 0
	var y = 0
	
	x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	y = Input.get_action_strength("jump")
	
	if x != 0:
		if x < 0:
			$playersprite.scale = Vector2(-1,1)
		elif x > 0:
			$playersprite.scale = Vector2(1,1)
		velocity.x = x * Walk
		
	else:
		velocity.x = move_toward(velocity.x, 0, Friction * delta)
	
	if y != 0:
		if is_on_floor():
			is_jumping = true
			jump_pressed_time = 0.0
		if is_jumping and jump_pressed_time < max_jump_time:
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
	
	velocity.y += Gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)
