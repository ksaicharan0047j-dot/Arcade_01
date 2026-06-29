extends Node2D

const GROUND_Y = 0
var buildings = []
var windows_data = []
var rng = RandomNumberGenerator.new()
var time_passed := 0.0

func _ready():
	rng.randomize()
	generate_city()
	queue_redraw()

func _process(delta):
	time_passed += delta
	queue_redraw()

func generate_city():
	buildings.clear()
	windows_data.clear()
	var layout = rng.randi() % 6
	var has_antenna = rng.randf() < 0.5
	var left_height
	var right_height
	match layout:
		0:#tall building
			left_height = rng.randf_range(95,120)
			right_height = rng.randf_range(55,80)
		1:
			left_height = rng.randf_range(55,80)
			right_height = rng.randf_range(95,120)
		2:
			left_height = rng.randf_range(95,120)
			right_height = rng.randf_range(75,95)
		3:
			left_height = rng.randf_range(75,95)
			right_height = rng.randf_range(95,120)
		4:
			left_height = rng.randf_range(75,95)
			right_height = rng.randf_range(55,80)
		5:
			left_height = rng.randf_range(55,80)
			right_height = rng.randf_range(75,95)
	buildings.append({
		"x": -28.0,
		"width": 34.0,
		"height": left_height,
		"window_cols": 2,
		"roof_type": rng.randi() % 3,
		"antenna": has_antenna,
		"beacon": has_antenna and rng.randf() < 0.4,
		"blink_speed": rng.randf_range(1.5,3.0),
		"blink_offset": rng.randf() * TAU
	})
	
	#Right building
	has_antenna = rng.randf() < 0.3
	buildings.append({
		"x": 4.0,
		"width": 46.0,
		"height": right_height,
		"window_cols": 3,
		"roof_type": rng.randi() % 3,
		"antenna": has_antenna,
		"beacon": has_antenna and rng.randf() < 0.25,
		"blink_speed": rng.randf_range(1.5,3.0),
		"blink_offset": rng.randf() * TAU
	})
	generate_windows()

func generate_windows():
	for b in buildings:
		var building_windows = []
		var win_h = 8
		var gap_y = 5
		var top_margin = 10
		var bottom_margin = 8
		var rows = max(
			2,
			int((b.height - top_margin - bottom_margin) / (win_h + gap_y))
		)
		for r in range(rows):
			var row = []
			for c in range(int(b.window_cols)):
				row.append({
					"lit": rng.randf() < 0.35,
					"warm": rng.randf() < 0.5
				})
			building_windows.append(row)
		windows_data.append(building_windows)

func _draw():
	draw_ground_shadow()
	for building in buildings:
		draw_building(building)

func draw_ground_shadow():
	draw_rect(
		Rect2(-65,4,130,5),
		Color(0,0,0,0.18)
	)

func draw_building(b):
	var x = b.x
	var w = b.width
	var h = b.height
	var y = -h
	#body
	draw_rect(
		Rect2(x,y,w,h),
		Color(0.23,0.24,0.27)
	)
	#left shadow
	draw_rect(
		Rect2(x,y,3,h),
		Color(0.15,0.16,0.18)
	)
	#Right moonlight
	draw_rect(
		Rect2(x+w-2,y,2,h),
		Color(0.42,0.43,0.46)
	)
	#Roof concrete 
	draw_rect(
		Rect2(x,y,w,4),
		Color(0.48,0.48,0.50)
	)
	draw_windows(b)
	draw_roof_details(b)
	if b.antenna:
		draw_antenna(b)
		if b.beacon:
			draw_beacon(b)

func draw_windows(b):
	var margin = 5
	var win_w = 6
	var win_h = 8
	var gap_x = 4
	var gap_y = 5
	var top_margin = 10
	var bottom_margin = 8
	var rows = max(
		2,
		int((b.height - top_margin - bottom_margin) / (win_h + gap_y))
	)
	var cols = int(b.window_cols)
	var start_x = b.x + margin
	var start_y = -b.height + top_margin
	for r in range(rows):
		for c in range(cols):
			var wx = start_x + c * (win_w + gap_x)
			var wy = start_y + r * (win_h + gap_y)
			var lit = rng.randf() < 0.35
			var color = Color(0.08,0.08,0.09)
			if lit:
				if rng.randf() < 0.5:
					color = Color(1.0,0.88,0.45)
				else:
					color = Color(0.82,0.90,1.0)
			draw_rect(
				Rect2(wx,wy,win_w,win_h),
				color
			)

func draw_roof_details(b):
	var roof_y = -b.height
	match b.roof_type:
		0:
			draw_rect(
				Rect2(b.x+3,roof_y-4,10,4),
				Color(0.55,0.55,0.57)
			)
			draw_rect(
				Rect2(b.x+b.width-13,roof_y-4,10,4),
				Color(0.55,0.55,0.57)
			)
		1:
			draw_rect(
				Rect2(b.x+b.width*0.5-7,roof_y-7,14,7),
				Color(0.52,0.52,0.55)
			)
		2:
			draw_rect(
				Rect2(b.x+b.width*0.5-5,roof_y-10,10,10),
				Color(0.48,0.48,0.50)
			)

func draw_antenna(b):
	var x = b.x + b.width*0.5
	var y = -b.height
	draw_line(
		Vector2(x,y),
		Vector2(x,y-18),
		Color(0.70,0.70,0.72),
		2
	)
	draw_line(
		Vector2(x-4,y-8),
		Vector2(x+4,y-8),
		Color(0.65,0.65,0.67),
		2
	)

func draw_beacon(b):
	var x = b.x + b.width*0.5
	var y = -b.height-18
	var brightness = (
		sin(
			time_passed * rng.randf_range(1.5,3.0) + b.height
		) + 1.0
	) * 0.5
	var alpha = lerp(0.15,1.0,brightness)
	draw_circle(
		Vector2(x,y),
		2,
		Color(1,0.2,0.2,alpha)
	)
	draw_circle(
		Vector2(x,y),
		5,
		Color(1,2.0,0.2,alpha*0.18)
	)
