extends CharacterBody2D

const SPEED := 105.0
const LOOK_AHEAD := 90.0

enum State {
	WAITING,
	MOVING
}

var state: State = State.WAITING

var current_marker: TurnMarker
var target_marker: TurnMarker
var direction := Vector2.DOWN

var released := false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var pacman: CharacterBody2D
var markers: Node


func _ready():
	sprite.play("move")

	var game = get_tree().current_scene

	pacman = game.get_node_or_null("PacmanPlayer")
	markers = game.get_node_or_null("Maze/Markers")

	if pacman == null:
		print("BLINKY ERROR: PacmanPlayer not found")
		return

	if markers == null:
		print("BLINKY ERROR: Markers not found")
		return

	current_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	if current_marker == null:
		print("BLINKY ERROR: GhostSpawn marker not found")
		return

	global_position = current_marker.global_position

	state = State.WAITING
	released = false

	print("BLINKY spawned at GhostSpawn")


func release_ghost():
	if released:
		return

	if current_marker == null:
		return

	released = true

	var next_marker = current_marker.get_next(Vector2.DOWN)

	if next_marker == null:
		print("BLINKY ERROR: GhostSpawn has no DOWN connection")
		released = false
		return

	print("BLINKY RELEASED")

	start_moving(next_marker, Vector2.DOWN)


func start_moving(next_marker: TurnMarker, new_direction: Vector2):
	target_marker = next_marker
	direction = new_direction
	state = State.MOVING

	update_sprite()


func _physics_process(delta):
	if not released:
		return

	if state == State.MOVING:
		move_to_target(delta)


func move_to_target(delta):
	if target_marker == null:
		state = State.WAITING
		return

	global_position = global_position.move_toward(
		target_marker.global_position,
		SPEED * delta
	)

	if global_position.distance_to(target_marker.global_position) <= 0.5:
		global_position = target_marker.global_position

		current_marker = target_marker

		choose_best_direction()


func choose_best_direction():
	if current_marker == null:
		return

	if pacman == null:
		return

	var target_position = get_prediction_position()

	var possible_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	var best_direction := Vector2.ZERO
	var best_distance := INF

	for candidate_direction in possible_directions:

		if candidate_direction == -direction:
			continue

		var next_marker = current_marker.get_next(candidate_direction)

		if next_marker == null:
			continue

		var distance = next_marker.global_position.distance_to(
			target_position
		)

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction != Vector2.ZERO:
		var next_marker = current_marker.get_next(best_direction)

		start_moving(
			next_marker,
			best_direction
		)
	else:
		var forward_marker = current_marker.get_next(direction)

		if forward_marker != null:
			start_moving(
				forward_marker,
				direction
			)
		else:
			state = State.WAITING


func get_prediction_position() -> Vector2:
	var prediction_direction = Vector2.ZERO

	if "direction" in pacman:
		prediction_direction = pacman.direction

	if prediction_direction == Vector2.ZERO:
		return pacman.global_position

	return pacman.global_position + (
		prediction_direction * LOOK_AHEAD
	)


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
