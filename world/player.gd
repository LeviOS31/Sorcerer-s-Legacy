extends KinematicBody2D

export (int) var Walk = 120
export (int) var Jump_speed = -200
export (int) var Gravity = 1000
export (int) var Friction = 10

var velocity = Vector2.ZERO
var jump_pressed_time = 0.0
var max_jump_time = 0.4
var is_jumping = false

onready var panimation = $AnimationPlayer
onready var animation = $AnimationTree
onready var anistate =  animation.get("parameters/playback")

func _ready():
	animation.active = true

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("walk_right"):
		velocity.x += Walk
	if Input.is_action_pressed("walk_left"):
		velocity.x -= Walk
	if Input.is_action_pressed("run"):
		velocity.x *= 1.7
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		jump_pressed_time = 0.0

	if Input.is_action_pressed("jump") and is_jumping and jump_pressed_time < max_jump_time:
		velocity.y = Jump_speed
		jump_pressed_time += get_process_delta_time()
	else:
		is_jumping = false

func _physics_process(delta):
	get_input()
	velocity.y += Gravity * delta
	velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	velocity = move_and_slide(velocity, Vector2.UP, true)
