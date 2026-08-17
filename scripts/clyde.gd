extends CharacterBody2D

const SPEED := 100.0
const CHASE_DISTANCE := 220.0
const LOOK_AHEAD := 60.0

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
var home_marker: TurnMarker


func _ready():
	sprite.play("move")

	var game = get_tree().current_scene

	if game == null:
		return

	pacman = game.get_node_or_null("PacmanPlayer")
	markers = game.get_node_or_null("Maze/Markers")

	if pacman == null:
		print("CLYDE ERROR: PacmanPlayer not found")
		return

	if markers == null:
		print("CLYDE ERROR: Markers not found")
		return

	current_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	if current_marker == null:
		print("CLYDE ERROR: GhostSpawn marker not found")
		return

	home_marker = current_marker

	global_position = current_marker.global_position

	state = State.WAITING
	released = false

	print("CLYDE spawned at GhostSpawn")


func release_ghost():
	if released:
		return

	if current_marker == null:
		return

	var next_marker = current_marker.get_next(Vector2.DOWN)

	if next_marker == null:
		print("CLYDE ERROR: GhostSpawn has no DOWN connection")
		return

	released = true

	start_moving(
		next_marker,
		Vector2.DOWN
	)

	print("CLYDE RELEASED")


func _physics_process(delta):
	if not released:
		return

	if state == State.MOVING:
		move_to_target(delta)


func start_moving(
	next_marker: TurnMarker,
	new_direction: Vector2
):
	if next_marker == null:
		return

	target_marker = next_marker
	direction = new_direction
	state = State.MOVING


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
		target_marker = null

		choose_direction()


func choose_direction():
	if current_marker == null:
		return

	if pacman == null:
		continue_forward()
		return

	var distance_to_pacman = global_position.distance_to(
		pacman.global_position
	)

	if distance_to_pacman <= CHASE_DISTANCE:
		go_home()
	else:
		chase_pacman()


func chase_pacman():
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

		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker == null:
			continue

		var distance = next_marker.global_position.distance_to(
			target_position
		)

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction != Vector2.ZERO:
		var next_marker = current_marker.get_next(
			best_direction
		)

		start_moving(
			next_marker,
			best_direction
		)
	else:
		continue_forward()


func go_home():
	if home_marker == null:
		continue_forward()
		return

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

		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker == null:
			continue

		var distance = next_marker.global_position.distance_to(
			home_marker.global_position
		)

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction != Vector2.ZERO:
		var next_marker = current_marker.get_next(
			best_direction
		)

		start_moving(
			next_marker,
			best_direction
		)
	else:
		continue_forward()


func continue_forward():
	if current_marker == null:
		return

	var next_marker = current_marker.get_next(direction)

	if next_marker != null:
		start_moving(
			next_marker,
			direction
		)
		return

	var possible_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	for candidate_direction in possible_directions:
		if candidate_direction == -direction:
			continue

		var alternative_marker = current_marker.get_next(
			candidate_direction
		)

		if alternative_marker != null:
			start_moving(
				alternative_marker,
				candidate_direction
			)
			return

	state = State.WAITING


func get_prediction_position() -> Vector2:
	var prediction_direction := Vector2.ZERO

	if "direction" in pacman:
		prediction_direction = pacman.direction

	if prediction_direction == Vector2.ZERO:
		return pacman.global_position

	return pacman.global_position + (
		prediction_direction * LOOK_AHEAD
	)


func wrap_through_tunnel(
	destination_marker: TurnMarker,
	destination_position: Vector2
):
	global_position = destination_position

	current_marker = destination_marker
	target_marker = null

	var next_marker = current_marker.get_next(direction)

	if next_marker != null:
		target_marker = next_marker
		state = State.MOVING
	else:
		state = State.WAITING
		direction = Vector2.ZERO
