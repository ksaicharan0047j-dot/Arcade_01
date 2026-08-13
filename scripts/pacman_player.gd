extends CharacterBody2D
const SPEED := 120.0

#Pacman Depth Effect

const SHADOW_COLOR := Color(0.0,0.0,0.0,0.38)
const DEEP_SHADOW_COLOR := Color(0.0,0.0,0.0,0.18)

const SHADOW_WIDTH := 18.0
const SHADOW_HEIGHT := 5.0

const BOB_HEIGHT := 1.5
const BOB_SPEED := 7.0

var depth_time := 0.0

enum State{
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
	depth_time = randf_range(0.0, TAU)
	if randi() % 2 == 0:
		current_marker = markers.get_node("PacmanSpawnLeft") as TurnMarker
	else:
		current_marker = markers.get_node("PacmanSpawnRight") as TurnMarker
	global_position = current_marker.global_position
	print("Pac-man Spawned at: ", current_marker.name)
	queue_redraw()

func _process(delta):
	#floating/depth effect
	depth_time += delta * BOB_SPEED
	queue_redraw()

func _draw():
	#small floating
	var bob := sin(depth_time) * BOB_HEIGHT
	
	#shadow follows Pac-Man's moment
	var shadow_offset := Vector2(2.0,5.0)
	
	if direction != Vector2.ZERO:
		shadow_offset += direction * -2.0
	var shadow_scale := 1.0
	
	if state == State.MOVING:
		shadow_scale = 0.9 + sin(depth_time * 1.5) * 0.08
		
		draw_ellipse_shape(
			shadow_offset + Vector2(0, bob * 0.3),
			Vector2(
				SHADOW_WIDTH * shadow_scale,
				SHADOW_HEIGHT * shadow_scale
			),
			DEEP_SHADOW_COLOR
		)
		draw_ellipse_shape(
		shadow_offset + Vector2(0, bob * 0.3),
		Vector2(
			SHADOW_WIDTH * 0.75 * shadow_scale,
			SHADOW_HEIGHT * 0.75 * shadow_scale
		),
		SHADOW_COLOR
	)


# Custom ellipse drawing
# Avoids touching Godot's built-in draw functions.
func draw_ellipse_shape(
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


func _physics_process(delta):

	if Input.is_action_just_pressed("ui_up"):
		wanted_direction = Vector2.UP

	if Input.is_action_just_pressed("ui_down"):
		wanted_direction = Vector2.DOWN

	if Input.is_action_just_pressed("ui_left"):
		wanted_direction = Vector2.LEFT

	if Input.is_action_just_pressed("ui_right"):
		wanted_direction = Vector2.RIGHT


	# =========================
	# WAITING
	# =========================

	if state == State.WAITING:

		if wanted_direction != Vector2.ZERO:

			var next_marker = current_marker.get_next(wanted_direction)

			if next_marker != null:

				start_moving(
					next_marker,
					wanted_direction
				)

				wanted_direction = Vector2.ZERO


	
	# MOVING
	
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

	# Move directly toward next marker
	global_position = global_position.move_toward(
		target_marker.global_position,
		SPEED * delta
	)


	# Reached marker
	if global_position.distance_to(
		target_marker.global_position
	) <= 0.5:

		global_position = target_marker.global_position

		current_marker = target_marker


		# Try buffered turn
		if wanted_direction != Vector2.ZERO:

			var turn_marker = current_marker.get_next(
				wanted_direction
			)

			if turn_marker != null:

				start_moving(
					turn_marker,
					wanted_direction
				)

				# Input successfully used
				wanted_direction = Vector2.ZERO

				return


		# Continue forward
		var forward_marker = current_marker.get_next(
			direction
		)

		if forward_marker != null:

			start_moving(
				forward_marker,
				direction
			)

		else:

			# No marker ahead
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

	# Teleport
	global_position = destination_position

	# Forget old marker
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

		print(
			"Next marker -> NONE"
		)
