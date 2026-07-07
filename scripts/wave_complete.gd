extends CanvasLayer

@onready var info = $Info

var cities_saved := 0
var launchers_left := 0
var missiles_left := 0
var bonus := 0

func show_results():
	info.text = \
	"       WAVE COMPLETED\n\n" + \
	"Cities Saved       %d\n" % cities_saved + \
	"launchers Left     %d\n" % launchers_left + \
	"Missiles Left      %d\n\n" % missiles_left + \
	"Bouns              %d\n\n" % bonus + \
	"PRESS SPACE"
	
	get_tree().paused = true

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		queue_free()
