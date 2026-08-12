extends Node2D
const POWER_TIME := 8.0

var power_mode := false
var power_timer := 0.0

func _ready():
	pass

func _process(delta):
	if power_mode:
		power_timer -= delta
		if power_timer <= 0.0:
			end_power_mode()

func activate_power_mode():
	power_mode = true
	power_timer = POWER_TIME
	print("🔥 POWER MODE ACTIVATED!")

func end_power_mode():
	power_mode = false
	power_timer = 0.0
	print("power mode ended.")
