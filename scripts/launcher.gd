extends Node2D

@export var launcher_type := 0
var target: Node2D = null
@onready var turret = $Turret

func _ready():
	turret.launcher_type = launcher_type

func _process(delta):
	if target == null:
		return
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
