extends Node2D

@export var launcher_type := 0

const MAX_MISSILES := 20

var missiles_left := MAX_MISSILES
var targets: Array[Node2D] = []
var fired := false
var missile_command: Node = null

@onready var turret = $Turret

func _ready():
	turret.launcher_type = launcher_type
	missile_command = get_parent().get_parent()

func _process(delta):

	# Remove destroyed targets from the front of the queue
	while !targets.is_empty() and !is_instance_valid(targets[0]):
		targets.pop_front()

	if targets.is_empty():
		fired = false
		return

	# Out of missiles
	if missiles_left <= 0:
		return

	var target = targets[0]

	var dir = target.global_position - turret.global_position
	var angle = dir.angle() + PI / 2.0

	angle = clamp(
		angle,
		deg_to_rad(-45),
		deg_to_rad(45)
	)

	turret.rotation = lerp_angle(
		turret.rotation,
		angle,
		6.0 * delta
	)

	if !fired and abs(turret.rotation - angle) < 0.03:

		fired = true

		missiles_left -= 1

		missile_command.launcher_player_missile(self, target)

		targets.pop_front()

		fired = false
