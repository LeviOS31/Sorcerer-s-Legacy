extends KinematicBody2D

enum{
	IDLE,
	WANDER,
	CHASE,
}

export var Friction = 1000
export var ACCL = 150
export var Speed = 120

onready var velocity = Vector2.ZERO
onready var State = WANDER
onready var wandercontroller = $wandercontroller


func _ready():
	randomize()

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
			pass
	
	velocity = move_and_slide(velocity)


func pick_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
