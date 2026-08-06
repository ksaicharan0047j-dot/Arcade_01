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
@onready var maze = $"../Maze"
@onready var markers = $"../Maze/Markers"


func _ready():
	randomize()

	sprite.play("move")

	# Random spawn
	if randi() % 2 == 0:
		current_marker = markers.get_node("PacmanSpawn1")
	else:
		current_marker = markers.get_node("PacmanSpawn2")

	global_position = current_marker.global_position


func _physics_process(delta):

	# Store player input (buffer)
	if Input.is_action_just_pressed("ui_up"):
		wanted_direction = Vector2.UP

	elif Input.is_action_just_pressed("ui_down"):
		wanted_direction = Vector2.DOWN

	elif Input.is_action_just_pressed("ui_left"):
		wanted_direction = Vector2.LEFT

	elif Input.is_action_just_pressed("ui_right"):
		wanted_direction = Vector2.RIGHT


	match state:

		State.WAITING:

			if wanted_direction != Vector2.ZERO:

				var next = current_marker.get_next(wanted_direction)

				if next != null:
					start_move(next, wanted_direction)


		State.MOVING:

			move_to_target(delta)



func start_move(next_marker: TurnMarker, dir: Vector2):

	target_marker = next_marker
	direction = dir

	state = State.MOVING

	update_sprite()



func move_to_target(delta):

	global_position = global_position.move_toward(
		target_marker.global_position,
		SPEED * delta
	)

	if global_position.distance_to(target_marker.global_position) < 1:

		global_position = target_marker.global_position
		current_marker = target_marker

		# Try buffered turn first
		if wanted_direction != Vector2.ZERO:

			var wanted = current_marker.get_next(wanted_direction)

			if wanted != null:

				start_move(wanted, wanted_direction)
				return

		# Otherwise continue straight
		var forward = current_marker.get_next(direction)

		if forward != null:

			start_move(forward, direction)

		else:

			state = State.WAITING
			target_marker = null
			direction = Vector2.ZERO



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
