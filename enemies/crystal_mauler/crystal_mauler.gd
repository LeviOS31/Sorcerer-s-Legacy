extends KinematicBody2D

enum{
	IDLE,
	MOVE,
}

export (int) var Speed = 100
export var friction = 1000
export var Accl = 20000

signal death()

var health = 5
var velocity = Vector2.ZERO
onready var animator = $AnimationPlayer
onready var sprite = $CrystalMauler
onready var State = IDLE
var is_attacking = false
var player
var died = false
onready var attack_timer = $attack_timer
var recharge = false

func _ready():
	randomize()
	player = get_tree().get_nodes_in_group("player")[0]

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	move(delta)

func _process(delta):
	if health < 1 && !died:
		death()

func move(delta):
	if !Global.is_in_dialogue && Global.cutscene_2_seen:
		if !died:
			if !is_attacking:
				match State:
					IDLE:
						velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
						if abs(global_position.x - player.global_position.x) > 100 || abs(global_position.x - player.global_position.x) < 50:
							State = MOVE
						elif !recharge:
							Attack()
							pass
					MOVE:
						var direction = 0
						if abs(global_position.x - player.global_position.x) > 100:
							direction = clamp(player.global_position.x - global_position.x, -1, 1)
						elif abs(global_position.x - player.global_position.x) < 50:
							direction = clamp(player.global_position.x - global_position.x, -1, 1)
							direction = -direction
						velocity = velocity.move_toward(Vector2(direction, 1) * Speed, Accl * delta)
						
						if abs(global_position.x - player.global_position.x) < 100 && abs(global_position.x - player.global_position.x) > 50:
							State = IDLE
							
				velocity = move_and_slide(velocity)
				if velocity.x != 0 && animator.current_animation != "hit" && !is_attacking:
					animator.play("run")
				else:
					animator.play("idle")
					
				if (player.global_position - global_position).normalized().x > 0:
					sprite.scale = Vector2(1,1)
				else:
					sprite.scale = Vector2(-1,1)

func _on_hurtbox_hit(enemy):
	if !died:
		animator.play("hit")
		print(enemy.global_position)
		var knockbackdirection = (global_position - enemy.global_position).normalized()
		velocity = velocity + (knockbackdirection * Global.knockbackspeed / 2)
		print("CM health: " + str(health))

func death():
	print("death")
	died = true
	animator.play("death")
	$CollisionShape2D.disabled = true
	emit_signal("death")
	yield(animator, "animation_finished")
	print("finished anim")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		animator.play("idle")
	elif anim_name == "attack-1" || anim_name == "attack-2":
		recharge = true
		attack_timer.start(1);
		is_attacking = false
	

func Attack():
	if !is_attacking:
		is_attacking = true
		if abs(global_position.y - player.global_position.y) > 80:
			print("attack high")
			animator.play("attack-2")
		else:
			if rand_range(100,0) > 80:
				animator.play("attack-2")
				print("attack high random")
			else:
				print("attack low")
				animator.play("attack-1")

func _on_attack_timer_timeout():
	recharge = false
