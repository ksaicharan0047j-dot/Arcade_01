extends CharacterBody2D

const SPEED := 105.0
const LOOK_AHEAD := 90.0
const TARGET_MIN_DISTANCE := 20.0

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

	if game == null:
		return

	pacman = game.get_node_or_null("PacmanPlayer")
	markers = game.get_node_or_null("Maze/Markers")

	if markers == null:
		return

	current_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	if current_marker == null:
		return

	global_position = current_marker.global_position

	state = State.WAITING
	target_marker = null
	direction = Vector2.DOWN
	released = false


func release_ghost():
	if released:
		return

	if current_marker == null:
		return

	var next_marker = current_marker.get_next(Vector2.DOWN)

	if next_marker == null:
		return

	released = true
	direction = Vector2.DOWN

	start_moving(next_marker, Vector2.DOWN)


func start_moving(next_marker: TurnMarker, new_direction: Vector2):
	if next_marker == null:
		state = State.WAITING
		target_marker = null
		return

	target_marker = next_marker
	direction = new_direction
	state = State.MOVING


func _physics_process(delta):
	if not released:
		return

	if state != State.MOVING:
		return

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
		target_marker = null

		choose_best_direction()


func choose_best_direction():
	if current_marker == null:
		return

	if pacman == null:
		return

	var target_position: Vector2 = get_prediction_position()

	var possible_directions := [
		Vector2.UP,
		Vector2.LEFT,
		Vector2.DOWN,
		Vector2.RIGHT
	]

	var best_direction := Vector2.ZERO
	var best_distance: float = INF

	for candidate_direction in possible_directions:

		if candidate_direction == -direction:
			continue

		var next_marker = current_marker.get_next(candidate_direction)

		if next_marker == null:
			continue

		var marker_position: Vector2 = next_marker.global_position

		var distance: float = marker_position.distance_to(
			target_position
		)

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction != Vector2.ZERO:
		var next_marker = current_marker.get_next(best_direction)

		if next_marker != null:
			start_moving(
				next_marker,
				best_direction
			)
			return

	var reverse_direction := -direction
	var reverse_marker = current_marker.get_next(reverse_direction)

	if reverse_marker != null:
		start_moving(
			reverse_marker,
			reverse_direction
		)
		return

	state = State.WAITING
	target_marker = null


func get_prediction_position() -> Vector2:
	if pacman == null:
		return global_position

	var prediction_direction := Vector2.ZERO

	if "direction" in pacman:
		prediction_direction = pacman.direction

	if prediction_direction == Vector2.ZERO:
		return pacman.global_position

	var predicted_position: Vector2 = (
		pacman.global_position +
		prediction_direction * LOOK_AHEAD
	)

	if predicted_position.distance_to(global_position) < TARGET_MIN_DISTANCE:
		return pacman.global_position

	return predicted_position
