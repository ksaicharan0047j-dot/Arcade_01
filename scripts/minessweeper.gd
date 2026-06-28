extends Node2D

const CELL_SIZE = 32
var cell_scene = preload("res://scenes/cell.tscn")
var board_size = 5
var mine_count = 5
var board = []
var board_origin = Vector2.ZERO
var game_over = false

func _ready():
	pass

func start_game(size, mines):
	print("Starting game:",size)
	board_size = size
	mine_count = mines
	create_board()

func create_board():
	board.clear()
	print("Creating board")
	for child in $Board.get_children():
		child.queue_free()
	var board_pixels = board_size * CELL_SIZE
	var start_x = (get_viewport_rect().size.x - board_pixels) / 2
	var start_y = (get_viewport_rect().size.y - board_pixels) / 2 + 30
	board_origin = Vector2(start_x, start_y)
	for y in range(board_size):
		board.append([])
		for x in range(board_size):
			var cell = cell_scene.instantiate()
			cell.grid_position = Vector2i(x,y)
			cell.position = Vector2(
				start_x + x * CELL_SIZE,
				start_y + y * CELL_SIZE
			)
			board[y].append(cell)
			$Board.add_child(cell)
	place_mines()
	calculated_numbers()

func _on_button_5x_5_pressed():
	start_game(5,5)
func _on_button_10x_10_pressed():
	start_game(10,15)
func _on_button_15x_15_pressed():
	start_game(15,35)

func place_mines():
	var placed = 0
	while placed < mine_count:
		var x = randi() % board_size
		var y = randi() % board_size
		if board[y][x].is_mine:
			continue
		board[y][x].is_mine = true
		placed += 1

func calculated_numbers():
	for y in range(board_size):
		for x in range(board_size):
			if board[y][x].is_mine:
				continue
			var count = 0
			for dy in range(-1,2):
				for dx in range(-1,2):
					var nx = x + dx
					var ny = y + dy
					if nx < 0 or ny < 0:
						continue
					if nx >= board_size or ny >= board_size:
						continue
					if board[ny][nx].is_mine:
						count += 1
			board[y][x].neighbour_count = count

func reveal_cell(x,y):
	var cell = board[y][x]
	if cell.revealed:
		return
	if cell.flagged:
		return
	cell.revealed = true
	cell.queue_redraw()
	if cell.is_mine:
		game_over = true
		for i in range(board_size):
			for j in range(board_size):
				if board[i][j].is_mine:
					board[i][j].revealed = true
					board[i][j].queue_redraw()
		$CanvasLayer/GameOverPanel.visible = true
		$CanvasLayer/GameOverPanel/GameOverLabel.text = "GAME OVER"
		return
	if cell.neighbour_count == 0:
		flood_fill(x,y)
	check_win()

func flood_fill(x,y):
	for dy in range(-1,2):
		for dx in range(-1,2):
			var nx = x + dx
			var ny = y + dy
			if nx < 0 or ny < 0:
				continue
			if nx >= board_size or ny >= board_size:
				continue
			var cell = board[ny][nx]
			if cell.revealed:
				continue
			if cell.is_mine:
				continue
			cell.revealed = true
			cell.queue_redraw()
			if cell.neighbour_count == 0:
				flood_fill(nx,ny)
	check_win()

func _unhandled_input(event):
	if game_over:
		return
	if event is InputEventMouseButton and event.pressed:
		var mouse = get_viewport().get_mouse_position()
		var local = mouse - board_origin
		var x = int(local.x / CELL_SIZE)
		var y = int(local.y / CELL_SIZE)
		if x < 0 or y < 0:
			return
		if x >= board_size or y >= board_size:
			return
		if event.button_index == MOUSE_BUTTON_LEFT:
			reveal_cell(x,y)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var cell = board[y][x]
			cell.flagged = !cell.flagged
			cell.queue_redraw()

func check_win():
	for y in range(board_size):
		for x in range(board_size):
			var cell = board[y][x]
			if !cell.is_mine and !cell.revealed:
				return
	game_over = true
	print("YOU WIN")
	$CanvasLayer/HBoxContainer.visible = false
	$CanvasLayer/GameOverPanel.visible = true
	$CanvasLayer/GameOverPanel/GameOverLabel.text = "YOU WIN!!"


func _on_restart_button_pressed():
	get_tree().reload_current_scene()
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
