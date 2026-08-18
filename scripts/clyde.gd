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
		print("CLYDE ERROR: GhostSpawn not found")
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
		choose_direction()
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

	var possible_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	var valid_directions: Array[Vector2] = []

	for candidate_direction in possible_directions:
		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker != null:
			valid_directions.append(candidate_direction)

	if valid_directions.is_empty():
		state = State.WAITING
		target_marker = null
		return

	if valid_directions.size() == 1:
		var only_direction = valid_directions[0]
		var only_marker = current_marker.get_next(only_direction)

		start_moving(
			only_marker,
			only_direction
		)

		return

	if pacman == null:
		choose_random_direction(valid_directions)
		return

	var distance_to_pacman := global_position.distance_to(
		pacman.global_position
	)

	if distance_to_pacman > CHASE_DISTANCE:
		go_home(valid_directions)
	else:
		chase_pacman(valid_directions)


func chase_pacman(valid_directions: Array[Vector2]):
	var target_position = get_prediction_position()

	var best_direction := Vector2.ZERO
	var best_distance: float = INF

	for candidate_direction in valid_directions:
		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker == null:
			continue

		var distance: float = next_marker.global_position.distance_to(
			target_position
		)

		if candidate_direction == direction:
			distance -= 5.0

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction == Vector2.ZERO:
		choose_random_direction(valid_directions)
		return

	var next_marker = current_marker.get_next(
		best_direction
	)

	start_moving(
		next_marker,
		best_direction
	)


func go_home(valid_directions: Array[Vector2]):
	if home_marker == null:
		choose_random_direction(valid_directions)
		return

	var best_direction := Vector2.ZERO
	var best_distance: float = INF

	for candidate_direction in valid_directions:
		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker == null:
			continue

		var distance: float = next_marker.global_position.distance_to(
			home_marker.global_position
		)

		if candidate_direction == direction:
			distance -= 3.0

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction == Vector2.ZERO:
		choose_random_direction(valid_directions)
		return

	var next_marker = current_marker.get_next(
		best_direction
	)

	start_moving(
		next_marker,
		best_direction
	)


func choose_random_direction(valid_directions: Array[Vector2]):
	if valid_directions.is_empty():
		state = State.WAITING
		return

	var chosen_direction = valid_directions.pick_random()

	var next_marker = current_marker.get_next(
		chosen_direction
	)

	if next_marker != null:
		start_moving(
			next_marker,
			chosen_direction
		)
	else:
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
	if destination_marker == null:
		return

	global_position = destination_position

	current_marker = destination_marker
	target_marker = null

	var next_marker = current_marker.get_next(direction)

	if next_marker != null:
		target_marker = next_marker
		state = State.MOVING
	else:
		state = State.WAITING
		choose_direction()
