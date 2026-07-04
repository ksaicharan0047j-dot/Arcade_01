extends Node2D

@export var launcher_type := 0
var targets: Array[Node2D] = []
var fired := false
var missile_command : Node = null
@onready var turret = $Turret

func _ready():
	turret.launcher_type = launcher_type
	missile_command = get_parent().get_parent()

func _process(delta):
	if targets.is_empty():
		fired = false
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
		missile_command.launcher_player_missile(self,target)
		targets.pop_front()
		fired = false
