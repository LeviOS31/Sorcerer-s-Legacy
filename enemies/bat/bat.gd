extends KinematicBody2D

enum{
	IDLE,
	WANDER,
	CHASE,
}

export var health = 2
export var Friction = 1000
export var ACCL = 200
export var Speed = 190

onready var velocity = Vector2.ZERO
onready var State = WANDER
onready var wandercontroller = $wandercontroller
var player


func _ready():
	get_player()
	randomize()

func _process(delta):
	if health <= 0:
		queue_free()

func _physics_process(delta):
	match State:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
			
			if wandercontroller.get_time() == 0:
				State = pick_state([IDLE, WANDER])
				wandercontroller.start_timer(rand_range(1,3))
			
		WANDER:
			if wandercontroller.get_time() == 0:
				State = pick_state([IDLE, WANDER])
				wandercontroller.start_timer(rand_range(1,3))
				
			var direction = global_position.direction_to(wandercontroller.target_position)
			velocity = velocity.move_toward(direction * Speed, ACCL * delta)
			
			if global_position.distance_to(wandercontroller.target_position)  <= Speed * delta:
				State = pick_state([IDLE, WANDER])
				wandercontroller.start_timer(rand_range(1,3))
		CHASE:
			var direction = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(direction * Speed, ACCL * delta)
	
	velocity = move_and_slide(velocity)


func pick_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func get_player():
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0:
		player = nodes[0]

func _on_detection_area_body_entered(body):
	if body.name == "player":
		State = CHASE

func _on_detection_area_body_exited(body):
	if body.name == "player":
		State = pick_state([IDLE, WANDER])
		wandercontroller.start_timer(rand_range(1,3))


func _on_hurtbox_hit():
	$AnimationPlayer.play("hit")
