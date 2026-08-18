extends CharacterBody2D

const SPEED := 98.0
const LOOK_AHEAD := 70.0

const TUNNEL_DISTANCE_TRIGGER := 350.0
const TUNNEL_ADVANTAGE := 80.0
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
var blinky: CharacterBody2D
var markers: Node

var tunnel_left: TurnMarker
var tunnel_right: TurnMarker


func _ready():
	sprite.play("move")

	var game = get_tree().current_scene

	if game == null:
		return

	pacman = game.get_node_or_null("PacmanPlayer")
	blinky = game.get_node_or_null("Ghosts/Blinky")
	markers = game.get_node_or_null("Maze/Markers")

	if pacman == null:
		print("INKY ERROR: PacmanPlayer not found")
		return

	if blinky == null:
		print("INKY ERROR: Blinky not found")
		return

	if markers == null:
		print("INKY ERROR: Markers not found")
		return

	current_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	tunnel_left = markers.get_node_or_null(
		"PacmanSpawnLeft"
	) as TurnMarker

	tunnel_right = markers.get_node_or_null(
		"PacmanSpawnRight"
	) as TurnMarker

	if current_marker == null:
		print("INKY ERROR: GhostSpawn not found")
		return

	if tunnel_left == null:
		print("INKY ERROR: PacmanSpawnLeft not found")

	if tunnel_right == null:
		print("INKY ERROR: PacmanSpawnRight not found")

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

	normal_inky_ai()


func decide_tunnel_route() -> bool:
	if tunnel_left == null or tunnel_right == null:
		return false

	if tunnel_cooldown > 0.0:
		return false

	var pacman_distance: float = global_position.distance_to(
		pacman.global_position
	)

	if pacman_distance < TUNNEL_DISTANCE_TRIGGER:
		return false

	var left_route = find_route_to_marker(
		current_marker,
		tunnel_left
	)

	var right_route = find_route_to_marker(
		current_marker,
		tunnel_right
	)

	var best_route: Array = []
	var best_exit_distance: float = INF
	var best_steps: int = 999999
	var best_target: TurnMarker = null

	if left_route.size() > 0:
		var left_steps: int = left_route[0]

		var left_exit_distance: float = tunnel_right.global_position.distance_to(
			pacman.global_position
		)

		if (
			left_exit_distance < best_exit_distance
			or (
				left_exit_distance == best_exit_distance
				and left_steps < best_steps
			)
		):
			best_route = left_route
			best_exit_distance = left_exit_distance
			best_steps = left_steps
			best_target = tunnel_left

	if right_route.size() > 0:
		var right_steps: int = right_route[0]

		var right_exit_distance: float = tunnel_left.global_position.distance_to(
			pacman.global_position
		)

		if (
			right_exit_distance < best_exit_distance
			or (
				right_exit_distance == best_exit_distance
				and right_steps < best_steps
			)
		):
			best_route = right_route
			best_exit_distance = right_exit_distance
			best_steps = right_steps
			best_target = tunnel_right

	if best_route.size() == 0:
		return false

	var tunnel_score: float = (
		float(best_steps) * 45.0
		+ best_exit_distance
	)

	var normal_distance: float = pacman_distance

	if tunnel_score + TUNNEL_ADVANTAGE >= normal_distance:
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
		normal_inky_ai()
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
		normal_inky_ai()
		return

	var route = find_route_to_marker(
		current_marker,
		tunnel_target
	)

	if route.size() == 0:
		tunnel_mode = false
		normal_inky_ai()
		return

	var route_direction: Vector2 = route[1]

	var tunnel_next_marker = current_marker.get_next(
		route_direction
	)

	if tunnel_next_marker == null:
		tunnel_mode = false
		normal_inky_ai()
		return

	start_moving(
		tunnel_next_marker,
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
			var route_marker = current.get_next(
				candidate_direction
			)

			if route_marker == null:
				continue

			if distances.has(route_marker):
				continue

			distances[route_marker] = distances[current] + 1

			if current == start:
				first_directions[route_marker] = candidate_direction
			else:
				first_directions[route_marker] = first_directions[current]

			if route_marker == target:
				return [
					distances[route_marker],
					first_directions[route_marker]
				]

			queue.append(route_marker)

	return []


func normal_inky_ai():
	var target_position := calculate_inky_target()

	var possible_directions = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]

	var best_direction := Vector2.ZERO
	var best_distance: float = INF

	for candidate_direction in possible_directions:
		var candidate_marker = current_marker.get_next(
			candidate_direction
		)

		if candidate_marker == null:
			continue

		if candidate_direction == -direction:
			continue

		var distance: float = candidate_marker.global_position.distance_to(
			target_position
		)

		if candidate_direction == direction:
			distance -= 4.0

		if distance < best_distance:
			best_distance = distance
			best_direction = candidate_direction

	if best_direction != Vector2.ZERO:
		var ai_next_marker = current_marker.get_next(
			best_direction
		)

		if ai_next_marker != null:
			start_moving(
				ai_next_marker,
				best_direction
			)
			return

	continue_forward()


func calculate_inky_target() -> Vector2:
	var pacman_direction := Vector2.ZERO

	if "direction" in pacman:
		pacman_direction = pacman.direction

	if pacman_direction == Vector2.ZERO:
		pacman_direction = Vector2.RIGHT

	var ahead_position := pacman.global_position + (
		pacman_direction * LOOK_AHEAD
	)

	var blinky_position := blinky.global_position

	var target := blinky_position + (
		(ahead_position - blinky_position) * 2.0
	)

	target.x = clamp(
		target.x,
		MAZE_LEFT,
		MAZE_RIGHT
	)

	target.y = clamp(
		target.y,
		MAZE_TOP,
		MAZE_BOTTOM
	)

	return target


func continue_forward():
	if current_marker == null:
		return

	var forward_marker = current_marker.get_next(direction)

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

	var reverse_marker = current_marker.get_next(-direction)

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

	var exit_marker = current_marker.get_next(direction)

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
