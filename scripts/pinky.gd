extends CharacterBody2D

const SPEED := 102.0
const LOOK_AHEAD_STEPS := 4

const TUNNEL_DISTANCE_TRIGGER := 350.0
const TUNNEL_AADVANTAGE := 80.0
const TUNNEL_COOLDOWN := 2.0

const MAZE_LEFT := 50.0
const MAZE_RIGHT := 1100.0
const MAZE_TOP := 50.0
const MAZE_BOTTOM := 540.0

enum State {
	WAITING,
	MOVING
}
var state: State = State.WAITING
var current_marker: TurnMarker
var target_marker: TurnMarker

var direction := Vector2.DOWN
var released := false
var tunnel_cooldown := 0.0
var tunnel_mode := false
var tunnel_target: TurnMarker = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var pacman: CharacterBody2D
var markers: Node

var tunnel_left: TurnMarker
var tunnel_right: TurnMarker


func _ready():
	sprite.play("move")

	var game = get_tree().current_scene

	if game == null:
		return
	pacman = game.get_node_or_null("PacmanPlayer")
	markers = game.get_node_or_null("Maze/Markers")

	if pacman == null:
		print("PINKY ERROR: PacmanPlayer not found")
		return

	if markers == null:
		print("PINKY ERROR: Markers not found")
		return
	current_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	tunnel_left = markers.get_node_or_null(
		"PacmanSpawnLeft"
	) as TurnMarker

	tunnel_right = markers.get_node_or_null(
		"PacmanSpawnRight"
	) as TurnMarker

	if current_marker == null:
		print("PINKY ERROR: GhostSpawn not found")
		return

	if tunnel_left == null:
		print("PINKY ERROR: PacmanSpawnLeft not found")

	if tunnel_right == null:
		print("PINKY ERROR: PacmanSpawnRight not found")

	global_position = current_marker.global_position

	state = State.WAITING
	released = false


func release_ghost():
	if released:
		return

	if current_marker == null:
		return

	var release_marker = current_marker.get_next(Vector2.DOWN)

	if release_marker == null:
		return

	released = true

	start_moving(
		release_marker,
		Vector2.DOWN
	)

func _physics_process(delta):
	if tunnel_cooldown > 0.0:
		tunnel_cooldown -= delta

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

		if tunnel_mode:
			continue_tunnel_route()
		else:
			choose_direction()


func choose_direction():
	if current_marker == null:
		return

	if pacman == null:
		continue_forward()
		return

	if tunnel_cooldown <= 0.0:
		if decide_tunnel_route():
			return

	pinky_ai()


func pinky_ai():
	var target_marker = calculate_pinky_target_marker()

	if target_marker == null:
		continue_forward()
		return

	var route = find_route_to_marker(
		current_marker,
		target_marker
	)

	if route.size() > 0:
		var wanted_direction: Vector2 = route[1]

		var next_marker = current_marker.get_next(
			wanted_direction
		)

		if next_marker != null:
			start_moving(
				next_marker,
				wanted_direction
			)
			return

	normal_fallback()


func calculate_pinky_target_marker() -> TurnMarker:
	if pacman == null:
		return null

	var pacman_marker: TurnMarker = find_nearest_marker(
		pacman.global_position
	)

	if pacman_marker == null:
		return null

	var pacman_direction: Vector2 = Vector2.ZERO

	if "direction" in pacman:
		pacman_direction = pacman.direction

	if pacman_direction == Vector2.ZERO:
		pacman_direction = Vector2.RIGHT

	var current_target: TurnMarker = pacman_marker

	for i in range(LOOK_AHEAD_STEPS):
		var next_marker: TurnMarker = current_target.get_next(
			pacman_direction
		)

		if next_marker == null:
			break

		current_target = next_marker

	return current_target

func find_nearest_marker(position: Vector2) -> TurnMarker:
	if markers == null:
		return null

	var best_marker: TurnMarker = null
	var best_distance: float = INF

	for child in markers.get_children():
		if child is TurnMarker:
			var marker := child as TurnMarker

			var distance: float = marker.global_position.distance_to(
				position
			)

			if distance < best_distance:
				best_distance = distance
				best_marker = marker

	return best_marker


func decide_tunnel_route() -> bool:
	if tunnel_left == null or tunnel_right == null:
		return false

	if tunnel_cooldown > 0.0:
		return false

	var distance_to_pacman: float = global_position.distance_to(
		pacman.global_position
	)

	if distance_to_pacman < TUNNEL_DISTANCE_TRIGGER:
		return false

	var left_route = find_route_to_marker(
		current_marker,
		tunnel_left
	)

	var right_route = find_route_to_marker(
		current_marker,
		tunnel_right
	)

	var best_score: float = INF
	var best_target: TurnMarker = null

	if left_route.size() > 0:
		var left_steps: int = left_route[0]

		var left_exit_distance: float = tunnel_right.global_position.distance_to(
			pacman.global_position
		)

		var left_score: float = (
			float(left_steps) * 45.0
			+ left_exit_distance
		)

		if left_score < best_score:
			best_score = left_score
			best_target = tunnel_left

	if right_route.size() > 0:
		var right_steps: int = right_route[0]

		var right_exit_distance: float = tunnel_left.global_position.distance_to(
			pacman.global_position
		)

		var right_score: float = (
			float(right_steps) * 45.0
			+ right_exit_distance
		)

		if right_score < best_score:
			best_score = right_score
			best_target = tunnel_right

	if best_target == null:
		return false

	if best_score + TUNNEL_ADVANTAGE >= distance_to_pacman:
		return false

	tunnel_target = best_target
	tunnel_mode = true

	continue_tunnel_route()

	return true


func continue_tunnel_route():
	if not tunnel_mode:
		return

	if tunnel_target == null:
		tunnel_mode = false
		pinky_ai()
		return

	if current_marker == tunnel_target:
		var destination_marker: TurnMarker = null

		if tunnel_target == tunnel_left:
			destination_marker = tunnel_right
		elif tunnel_target == tunnel_right:
			destination_marker = tunnel_left

		if destination_marker != null:
			wrap_through_tunnel(
				destination_marker,
				destination_marker.global_position
			)
			return

		tunnel_mode = false
		pinky_ai()
		return

	var route = find_route_to_marker(
		current_marker,
		tunnel_target
	)

	if route.size() == 0:
		tunnel_mode = false
		pinky_ai()
		return

	var route_direction: Vector2 = route[1]

	var next_marker = current_marker.get_next(
		route_direction
	)

	if next_marker == null:
		tunnel_mode = false
		pinky_ai()
		return

	start_moving(
		next_marker,
		route_direction
	)


func find_route_to_marker(
	start: TurnMarker,
	target: TurnMarker
) -> Array:

	if start == null or target == null:
		return []

	if start == target:
		return [0, Vector2.ZERO]

	var queue: Array = []
	var distances := {}
	var first_directions := {}

	queue.append(start)
	distances[start] = 0

	while queue.size() > 0:
		var current: TurnMarker = queue.pop_front()

		var possible_directions = [
			Vector2.UP,
			Vector2.DOWN,
			Vector2.LEFT,
			Vector2.RIGHT
		]

		for candidate_direction in possible_directions:
			var next_marker = current.get_next(
				candidate_direction
			)

			if next_marker == null:
				continue

			if distances.has(next_marker):
				continue

			distances[next_marker] = distances[current] + 1

			if current == start:
				first_directions[next_marker] = candidate_direction
			else:
				first_directions[next_marker] = first_directions[current]

			if next_marker == target:
				return [
					distances[next_marker],
					first_directions[next_marker]
				]

			queue.append(next_marker)

	return []

func normal_fallback():
	if current_marker == null:
		return

	var possible_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	var best_direction := Vector2.ZERO
	var best_distance: float = INF

	for candidate_direction in possible_directions:
		if candidate_direction == -direction:
			continue

		var next_marker = current_marker.get_next(
			candidate_direction
		)

		if next_marker == null:
			continue

		var distance: float = next_marker.global_position.distance_to(
			pacman.global_position
		)

		if candidate_direction == direction:
			distance -= 5.0

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
		return

	continue_forward()


func continue_forward():
	if current_marker == null:
		return

	var forward_marker = current_marker.get_next(
		direction
	)

	if forward_marker != null:
		start_moving(
			forward_marker,
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

		var escape_marker = current_marker.get_next(
			candidate_direction
		)

		if escape_marker != null:
			start_moving(
				escape_marker,
				candidate_direction
			)
			return

	var reverse_marker = current_marker.get_next(
		-direction
	)

	if reverse_marker != null:
		start_moving(
			reverse_marker,
			-direction
		)
		return

	state = State.WAITING


func wrap_through_tunnel(
	destination_marker: TurnMarker,
	destination_position: Vector2
):
	if destination_marker == null:
		return

	global_position = destination_position

	current_marker = destination_marker
	target_marker = null

	tunnel_mode = false
	tunnel_target = null
	tunnel_cooldown = TUNNEL_COOLDOWN

	var exit_marker = current_marker.get_next(
		direction
	)

	if exit_marker != null:
		start_moving(
			exit_marker,
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
		var escape_marker = current_marker.get_next(
			candidate_direction
		)

		if escape_marker != null:
			start_moving(
				escape_marker,
				candidate_direction
			)
			return

	state = State.WAITING
