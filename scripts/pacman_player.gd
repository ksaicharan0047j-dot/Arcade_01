extends CharacterBody2D

const NORMAL_SPEED := 120.0
const POWER_SPEED := 165.0

const POWER_TIME := 8.0
const POWER_SCALE := 1.25
const POWER_COLOR := Color(1.0, 0.3, 0.05)

const SHADOW_COLOR := Color(0.0, 0.0, 0.0, 0.35)
const SHADOW_RADIUS_X := 17.0
const SHADOW_RADIUS_Y := 4.0

var speed := NORMAL_SPEED

var power_mode := false
var power_timer := 0.0

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

	print("Pacman spawned at: ", current_marker.name)

	queue_redraw()

func _draw():
	draw_shadow_ellipse(
		Vector2(2, 7),
		Vector2(SHADOW_RADIUS_X, SHADOW_RADIUS_Y),
		SHADOW_COLOR
	)

func draw_shadow_ellipse(
	position: Vector2,
	radius: Vector2,
	color: Color
):
	var points := PackedVector2Array()

	for i in range(32):
		var angle := TAU * float(i) / 32.0

		points.append(
			position + Vector2(
				cos(angle) * radius.x,
				sin(angle) * radius.y
			)
		)

	draw_colored_polygon(points, color)

func activate_power_mode():
	power_mode = true
	power_timer = POWER_TIME

	speed = POWER_SPEED

	sprite.scale = Vector2(
		POWER_SCALE,
		POWER_SCALE
	)

	sprite.modulate = POWER_COLOR

	print("PACMAN POWER MODE ACTIVATED!")
	print("POWER TIMER: ", POWER_TIME)

	queue_redraw()

func deactivate_power_mode():
	if not power_mode:
		return

	power_mode = false
	power_timer = 0.0

	speed = NORMAL_SPEED

	sprite.scale = Vector2.ONE
	sprite.modulate = Color.WHITE

	print("PACMAN POWER MODE ENDED!")

	queue_redraw()

func _physics_process(delta):

	if power_mode:
		power_timer -= delta

		if power_timer <= 0.0:
			deactivate_power_mode()

	if Input.is_action_just_pressed("ui_up"):
		wanted_direction = Vector2.UP

	if Input.is_action_just_pressed("ui_down"):
		wanted_direction = Vector2.DOWN

	if Input.is_action_just_pressed("ui_left"):
		wanted_direction = Vector2.LEFT

	if Input.is_action_just_pressed("ui_right"):
		wanted_direction = Vector2.RIGHT

	if state == State.WAITING:

		if wanted_direction != Vector2.ZERO:

			var next_marker = current_marker.get_next(
				wanted_direction
			)

			if next_marker != null:
				start_moving(
					next_marker,
					wanted_direction
				)

				wanted_direction = Vector2.ZERO

	elif state == State.MOVING:

		move_to_target(delta)

func start_moving(
	next_marker: TurnMarker,
	new_direction: Vector2
):

	print(
		"FROM: ",
		current_marker.name,
		" TO: ",
		next_marker.name,
		" DIR: ",
		new_direction
	)

	target_marker = next_marker
	direction = new_direction
	state = State.MOVING

	update_sprite()

func move_to_target(delta):

	global_position = global_position.move_toward(
		target_marker.global_position,
		speed * delta
	)

	if global_position.distance_to(
		target_marker.global_position
	) <= 0.5:

		global_position = target_marker.global_position
		current_marker = target_marker

		if wanted_direction != Vector2.ZERO:

			var turn_marker = current_marker.get_next(
				wanted_direction
			)

			if turn_marker != null:

				start_moving(
					turn_marker,
					wanted_direction
				)

				wanted_direction = Vector2.ZERO
				return

		var forward_marker = current_marker.get_next(
			direction
		)

		if forward_marker != null:

			start_moving(
				forward_marker,
				direction
			)

		else:

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

	global_position = destination_position

	current_marker = destination_marker
	target_marker = null

	var next_marker = current_marker.get_next(
		direction
	)

	if next_marker != null:

		target_marker = next_marker
		state = State.MOVING

	else:

		state = State.WAITING
		direction = Vector2.ZERO

	print(
		"Tunnel wrap -> ",
		current_marker.name
	)

	if target_marker != null:

		print(
			"Next marker -> ",
			target_marker.name
		)

	else:

		print("Next marker -> NONE")
