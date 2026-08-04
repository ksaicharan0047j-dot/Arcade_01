extends CharacterBody2D
const SPEED := 120.0
const TILE_SIZE := 16.0
const TURN_TOLERANCE := 3.0
enum State{
	WAITING,
	MOVING,
	DEATH
}
var state = State.WAITING
var direction = Vector2.LEFT
var wanted_direction := Vector2.LEFT
var lane_x := 0.0
var lane_y := 0.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_up: RayCast2D = $RayUp
@onready var ray_down: RayCast2D = $RayDown
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight

func _ready():
	sprite.play("move")
	velocity = Vector2.ZERO
	lane_x = position.x
	lane_y = position.y

func _physics_process(delta):
	if state == State.WAITING:
		velocity = Vector2.ZERO
		if Input.is_action_just_pressed("ui_up"):
			wanted_direction = Vector2.UP
			direction = wanted_direction
			state = State.MOVING
		elif Input.is_action_just_pressed("ui_down"):
			wanted_direction = Vector2.DOWN
			direction = wanted_direction
			state = State.MOVING
		elif Input.is_action_just_pressed("ui_left"):
			wanted_direction = Vector2.LEFT
			direction = wanted_direction
			state = State.MOVING
		elif Input.is_action_just_pressed("ui_right"):
			wanted_direction = Vector2.RIGHT
			direction = wanted_direction
			state = State.MOVING
	else:
		if Input.is_action_just_pressed("ui_up"):
			wanted_direction = Vector2.UP
		elif Input.is_action_just_pressed("ui_down"):
			wanted_direction = Vector2.DOWN
		elif Input.is_action_just_pressed("ui_left"):
			wanted_direction = Vector2.LEFT
		elif Input.is_action_just_pressed("ui_right"):
			wanted_direction = Vector2.RIGHT
		
		#buffer turing only at centers
		if can_move(wanted_direction) and is_centered():
			direction = wanted_direction
			if direction == Vector2.LEFT or direction == Vector2.RIGHT:
				lane_y = round(position.y / TILE_SIZE) * TILE_SIZE
				position.y = lane_y
			else:
				lane_x = round(position.x / TILE_SIZE) * TILE_SIZE
				position.x = lane_x
		
		#move only in the current direction
		if direction == Vector2.RIGHT:
			position.y = lane_y
			if !ray_right.is_colliding():
				position.x += SPEED * delta
		elif direction == Vector2.LEFT:
			position.y = lane_y
			if !ray_left.is_colliding():
				position.x -= SPEED * delta
		elif direction == Vector2.UP:
			position.x = lane_x
			if !ray_up.is_colliding():
				position.y -= SPEED * delta
		elif direction == Vector2.DOWN:
			position.x = lane_x
			if !ray_down.is_colliding():
				position.y += SPEED * delta
	update_sprite()

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

func can_move(dir: Vector2) -> bool:
	if dir == Vector2.UP:
		return !ray_up.is_colliding()
	elif dir == Vector2.DOWN:
		return !ray_down.is_colliding()
	elif dir == Vector2.LEFT:
		return !ray_left.is_colliding()
	elif dir == Vector2.RIGHT:
		return !ray_right.is_colliding()
	return false

func is_centered() -> bool:
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		var center_y = round(position.y/ TILE_SIZE) * TILE_SIZE
		return abs(position.y - center_y) <= TURN_TOLERANCE
	else:
		var center_x = round(position.x / TILE_SIZE) * TILE_SIZE
		return abs(position.x - center_x) <= TURN_TOLERANCE
