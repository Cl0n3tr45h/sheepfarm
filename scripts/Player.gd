extends KinematicBody2D

var velocity = Vector2.ZERO
var input_vector = Vector2()
var last_position = Vector2()
var target_position = Vector2()

signal moved

const ACCELERATION = 500
const MAX_SPEED = 200
const FRICTION = 600
const TILESIZE  = 50

onready var ray = $RayCast2D
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.

func _ready():
# warning-ignore:integer_division
	position = position.snapped(Vector2(TILESIZE,TILESIZE)) - Vector2(TILESIZE/2.0, TILESIZE/2.0)
	last_position = position
	target_position = position

func _process(delta):
	#MOVEMENT
	
	if ray.is_colliding():
		position = last_position
		target_position = last_position
	else:
		position += MAX_SPEED * input_vector * delta
		
		
		var walked_distance = position.distance_to(last_position)
		ray.cast_to = input_vector * (TILESIZE - walked_distance)
		
		if position.distance_to(last_position) >= TILESIZE:
			position = target_position
		emit_signal("moved")
		
	#IDLE
	if position == target_position:
		get_input_vector()
		last_position = position
		target_position += input_vector * TILESIZE


func get_input_vector():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	input_vector.x = int(RIGHT) - int(LEFT) #no opposite directions at the same time
	input_vector.y = int(DOWN) - int(UP) 
	
	if input_vector.x != 0 && input_vector.y != 0:  #no diagonals
		input_vector = Vector2.ZERO
	
	if input_vector.x > 0:
		animationState.travel("walk_right")
	if input_vector.x < 0:
		animationState.travel("walk_left")
	if input_vector.y > 0:
		animationState.travel("walk_forward")
	if input_vector.y < 0:
		animationState.travel("walk_backward")
	
	ray.cast_to = input_vector * TILESIZE



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
