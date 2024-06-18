extends KinematicBody2D

enum{
	IDLE,
	MOVE,
}

export (int) var Speed = 70
export var friction = 1000
export var Accl = 20000

signal death()

var health = 5
var velocity = Vector2.ZERO
onready var animator = $AnimationPlayer
onready var sprite = $Sprite
onready var State = IDLE
var is_attacking = false
var player
var died = false
onready var attack_timer = $attack_timer
var recharge = false


func _ready():
	randomize()
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	move(delta)

func _process(delta):
	if health < 1 && !died:
		death()

func move(delta):
	if !Global.is_in_dialogue && Global.cutscene_3_seen:
		if !died:
			if !is_attacking:
				match State:
					IDLE:
						velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
						if abs(global_position.x - player.global_position.x) > 100 || abs(global_position.x - player.global_position.x) < 50:
							State = MOVE
						elif !recharge:
							Attack()
							return

func death():
	died = true
	animator.play("RESET")
	animator.play("death")
	$CollisionShape2D.disabled = true
	emit_signal("death")
	yield(animator, "animation_finished")

func Attack():
	if !is_attacking:
		is_attacking = true
		if abs(global_position.y - player.global_position.y) > 80:
			print("attack high")
			animator.play("attack_1")
		else:
			if rand_range(100,0) > 80:
				animator.play("attack_1")
				print("attack high random")
			else:
				print("attack low")
				animator.play("attack_2")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		print("hit boss")
		animator.play("idle")
	elif anim_name == "attack_1" || anim_name == "attack_2":
		print("boss attack")
		recharge = true
		attack_timer.start(3);
		is_attacking = false

func _on_hurtbox_hit(enemy):
	if !died:
		#animator.play("RESET")
		is_attacking = false
		animator.play("hit")
		print(enemy.global_position)
		var knockbackdirection = (global_position - enemy.global_position).normalized()
		velocity = velocity + (knockbackdirection * Global.knockbackspeed / 2)
		print("CM health: " + str(health))

func _on_attack_timer_timeout():
	recharge = false
