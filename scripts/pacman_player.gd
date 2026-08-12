extends CharacterBody2D
const SPEED := 120.0
enum State {
	WAITING,
	MOVING
}

var state: State = State.WAITING
var current_marker: TurnMarker
var target_marker: TurnMarker
var direction := Vector2.ZERO
var wanted_direction := Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var markers = $"../Maze/Markers"
func _ready():
	randomize()
	
	sprite.play("move")
	if randi() % 2 == 0:
		current_marker = markers.get_node("PacmanSpawnLeft") as TurnMarker
	else:
		current_marker = markers.get_node("PacmanSpawnRight") as TurnMarker
	global_position = current_marker.global_position
	print("Pac-man spawned at: ", current_marker.name)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		wanted_direction = Vector2.UP
	if Input.is_action_just_pressed("ui_down"):
		wanted_direction = Vector2.DOWN
	if Input.is_action_just_pressed("ui_left"):
		wanted_direction = Vector2.LEFT
	if Input.is_action_just_pressed("ui_right"):
		wanted_direction = Vector2.RIGHT
	
	#waiting
	if state == State.WAITING:
		if wanted_direction != Vector2.ZERO:
			var next_marker = current_marker.get_next(wanted_direction)
			if next_marker != null:
				start_moving(next_marker, wanted_direction)
				
				wanted_direction = Vector2.ZERO
	
	elif state == State.MOVING:
		move_to_target(delta)

func start_moving(next_marker: TurnMarker, new_direction: Vector2):
	print("FROM: ", current_marker.name,
			" TO: ", next_marker.name,
			" DIR: ", new_direction)
	target_marker = next_marker
	direction = new_direction
	state = State.MOVING
	update_sprite()
	
func move_to_target(delta):
	#move directly toward the nexr marker
	global_position = global_position.move_toward(
		target_marker.global_position,
		SPEED * delta
	)
	#reached marker
	if global_position.distance_to(target_marker.global_position) <= 0.5:
		global_position = target_marker.global_position
		current_marker = target_marker
		#try buffered turn
		if wanted_direction != Vector2.ZERO:
			var turn_marker = current_marker.get_next(wanted_direction)
			if turn_marker != null:
				start_moving(
					turn_marker,
					wanted_direction
				)
				#inpur was successfully used
				wanted_direction = Vector2.ZERO
				return
		#continue 
		var forward_marker = current_marker.get_next(direction)
		if forward_marker != null:
			start_moving(
				forward_marker,
				direction
			)
		else:
			#no marker ahead
			state = State.WAITING
			target_marker = null

func update_sprite():
	match direction:
		Vector2.RIGHT:
			sprite.rotation_degrees = 0
		Vector2.LEFT:
			sprite.rotation_degrees = 180
		Vector2.UP:
			sprite.rotation_degrees = -90
		Vector2.DOWN:
			sprite.rotation_degrees = 90

func wrap_through_tunnel(
	destination_marker: TurnMarker,
	destination_position: Vector2
):
	#teleport
	global_position = destination_position
	#forget the marker
	current_marker  = destination_marker
	target_marker = null
	var next_marker = current_marker.get_next(direction)
	if next_marker != null:
		target_marker = next_marker
		state = State.MOVING
	else:
		state = State.WAITING
		direction = Vector2.ZERO
	print("Tunnel wrap -> ", current_marker.name)
	if target_marker != null:
		print("Next marker -> ", target_marker.name)
	else:
		print("Next marker -> NONE")
