extends CharacterBody2D

const SPEED := 80.0

enum State {
	WAITING,
	MOVING
}

var state: State = State.WAITING
var current_marker: TurnMarker
var target_marker: TurnMarker
var direction := Vector2.ZERO
var released := false

@export var ghost_color_row := 0

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	setup_sprite()
	call_deferred("spawn_at_ghost_box")

func setup_sprite():
	sprite.texture = preload("res://sprites/PacManAssets-Ghosts.png")
	sprite.hframes = 8
	sprite.vframes = 22
	sprite.frame = ghost_color_row * 8
	sprite.scale = Vector2(2.0, 2.0)

func spawn_at_ghost_box():
	var game = get_tree().current_scene

	if game == null:
		print("ERROR: Current game scene not found for ", name)
		return

	var maze = game.get_node_or_null("Maze")

	if maze == null:
		print("ERROR: Maze not found for ", name)
		return

	var markers = maze.get_node_or_null("Markers")

	if markers == null:
		print("ERROR: Maze/Markers not found for ", name)
		return

	var spawn_marker = markers.get_node_or_null("GhostSpawn") as TurnMarker

	if spawn_marker == null:
		print("ERROR: GhostSpawn marker not found for ", name)
		return

	current_marker = spawn_marker
	target_marker = null
	direction = Vector2.ZERO
	state = State.WAITING
	released = false

	global_position = current_marker.global_position
	visible = true

	print(name, " spawned at: ", current_marker.name)

func release_ghost():
	if released:
		return

	if current_marker == null:
		print("ERROR: ", name, " current_marker is NULL")
		return

	released = true

	var next_marker = current_marker.get_next(Vector2.DOWN)

	if next_marker == null:
		print("ERROR: GhostSpawn has no DOWN connection for ", name)
		released = false
		return

	print(name, " RELEASED")

	start_moving(
		next_marker,
		Vector2.DOWN
	)

func start_moving(
	next_marker: TurnMarker,
	new_direction: Vector2
):
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

		var next_marker = current_marker.get_next(direction)

		if next_marker != null:
			start_moving(
				next_marker,
				direction
			)
		else:
			state = State.WAITING
			target_marker = null
