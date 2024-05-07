extends KinematicBody2D

export (int) var Walk = 120
export (int) var Jump_speed = -225
export (int) var Gravity = 1000
export (int) var Friction = 1900

var health
var velocity = Vector2.ZERO
var jump_pressed_time = 0.0
var max_jump_time = 0.30
var is_jumping = false
export var is_attacking = false
var jump_amount = 0;

onready var panimation = $AnimationPlayer
onready var tanimation = $AnimationTree
onready var anistate = tanimation.get("parameters/playback")

func _ready():
	health = Playerstats.max_health

func _physics_process(delta):
	move(delta)
	

func _process(_delta):
	if !Global.is_in_dialogue:
		if Input.get_action_strength("attack") > 0:
			is_attacking = true
			attack()
		else:
			if is_attacking == true:
				attack_finished()
			is_attacking = false

func move(delta):
	if !Global.is_in_dialogue:
		if(!is_attacking):
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
			
			if Input.is_action_just_pressed("jump") and (is_on_floor() or (Playerstats.dubblejump and jump_amount < 2)):
				is_jumping = true
				jump_pressed_time = 0.0
				jump_amount += 1
			if Input.is_action_pressed("jump") and is_jumping and jump_pressed_time < max_jump_time:
				velocity.y = Jump_speed
				jump_pressed_time += delta
			if Input.is_action_just_released("jump"):
				is_jumping = false
			if is_on_floor():
				jump_amount = 0;
			
			
			if velocity.y < 0 and !is_on_floor():
				anistate.travel("jump")
			elif velocity.y > 0 and !is_on_floor():
				anistate.travel("fall")
			elif velocity.x != 0:
				anistate.travel("run")
			else:
				anistate.travel("idle")
		
		if is_attacking:
			velocity.x = move_toward(velocity.x, 0, 200 * delta)
			
		velocity.y += Gravity * delta
		velocity.y = clamp(velocity.y, -100000, 1500)
		if is_jumping:
			velocity = move_and_slide(velocity ,Vector2.UP, true)
		else:
			velocity = move_and_slide_with_snap(velocity, Vector2(0,10) ,Vector2.UP, true)
	else:
		velocity = move_and_slide(Vector2.ZERO)
		anistate.travel("idle")
	

func attack():
	anistate.travel("attack")
	$playersprite/hitbox.attacktype = "ongoing"
	$playersprite/hitbox/CollisionShape2D.disabled = false

func attack_finished():
	$playersprite/hitbox/CollisionShape2D.disabled = true
	$playersprite/hitbox.attacktype = ""
	$playersprite/Particles2D.emitting = false
	yield(get_tree().create_timer(0.1), "timeout")
	$playersprite/hurtbox/Position2D.strength = 0
	$playersprite/hurtbox/Position2D2.strength = 0

func _on_hurtbox_hit(enemy):
	#print("hit")
	panimation.play("damage")
	print(enemy.global_position)
	var knockbackdirection = (global_position - enemy.global_position).normalized()
	velocity = velocity + knockbackdirection * Global.knockbackspeed
