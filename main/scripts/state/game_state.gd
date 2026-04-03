class_name GameState

var status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var last_status: GAME_STATUS = GAME_STATUS.NOT_STARTED
var active_time: float
var last_drop_time: float
var last_slide_time: float
var current_active_shape: Shape
var next_active_shape: Shape
var gravity: float = 0.5 # seconds per tile drop
var speed_up: bool = false
enum GAME_STATUS { NOT_STARTED, ACTIVE, PAUSED, LOST }

# grid is an array of tiles with 0 representing empty higher values representing colored blocks 
var grid: Array[int]

var difficulty_coefficient: float:
	get: return 1 + (active_time / GameConstants.DIFFICULTY_RAMP) 

func initialize():
	# set up initial conditions
	active_time = 0
	last_drop_time = 0
	current_active_shape = null
	next_active_shape = null
	grid.resize(GameConstants.TILE_COUNT)
	grid.fill(GameConstants.TILE.NONE)

func start():
	Player.reset_score()
	status = GAME_STATUS.ACTIVE
	generate_new_active_tile_shape()
	generate_new_active_tile_shape() # Generates a second so we have one in the queue

func get_total_gravity():
	if speed_up:
		return gravity / difficulty_coefficient / GameConstants.TILE_DROP_SPEEDUP
	return gravity / difficulty_coefficient

func toggle_pause():
	if status == GAME_STATUS.PAUSED:
		status = last_status
	else:
		last_status = status
		status = GAME_STATUS.PAUSED

func move_active_blocks(direction: Vector2i):
	if can_move_active_blocks(direction):
		current_active_shape.offset += direction
		last_slide_time = active_time

func can_move_active_blocks(direction: Vector2i):
	if active_time < last_slide_time + GameConstants.SLIDE_TIME:
		return false
	if not current_active_shape or current_active_shape\
		.get_tiles_with_rot_and_offset(current_active_shape.rotation, current_active_shape.offset + direction)\
		.any(illegal_position):
		return false
	return true

func rotate_active_blocks():
	if can_rotate_active_blocks():
		current_active_shape.rotate()

func can_rotate_active_blocks():
	# TODO: this is not stopping us from rotating!
	if current_active_shape\
		.get_tiles_with_rot_and_offset(current_active_shape.rotation + 1, current_active_shape.offset)\
		.any(illegal_position):
		return false
	return true

func illegal_position(tile: Vector2i):
	return tile.x >= GameConstants.WIDTH \
	|| tile.x < 0 \
	|| tile.y >= GameConstants.HEIGHT \
	|| tile.y < 0 \
	|| grid[Grid.v2i_to_index(tile)] > 0

func update(delta: float):
	if status == GAME_STATUS.ACTIVE:
		active_time += delta
		if active_time - last_drop_time > get_total_gravity():
			# drop current dropping tiles
			last_drop_time = active_time
			if current_active_shape:
				if is_current_shape_touching_ground():
					Sfx.request_sound(SFX.Key.IMPACT)
					convert_active_tiles_to_grid()
					check_and_clear_rows()
					update_game_state()
					generate_new_active_tile_shape()
				else:
					current_active_shape.offset += Vector2i(0, 1)
				
func check_and_clear_rows():
	# this should go from top down since the row clears can cause things to fall!
	for i in range(0, GameConstants.HEIGHT):
		if can_clear_row(i):
			Sfx.request_sound(SFX.Key.CLEAR)
			clear_row(i)

func clear_row(row: int):
	var old_row: Array[int] = grid.slice(row * GameConstants.WIDTH, (row + 1) * GameConstants.WIDTH + 1)
	Events.on_row_clear.emit(row, old_row)

	# make all above rows fall by slicing the values in the removed row out, 
	# then adding in a blank row at top
	var fresh_row = []
	fresh_row.resize(GameConstants.WIDTH)
	fresh_row.fill(0)
	var new_grid = fresh_row + grid.slice(0, row * GameConstants.WIDTH) + grid.slice((row + 1) * GameConstants.WIDTH, GameConstants.TILE_COUNT + 1)
	grid = []
	for value in new_grid:
		grid.append(value)
	
	# add score
	Player.add_score(100)

func update_game_state():
	# check if any grid tiles are in the top row and lose if so
	for i in range(GameConstants.WIDTH):
		if grid[i] != 0:
			status = GAME_STATUS.LOST
		

func is_touching_ground(tile: Vector2i):
	# return true if on the bottom row
	if tile.y >= GameConstants.HEIGHT - 1:
		return true
	var tile_index = Grid.v2i_to_index(tile)
	var below_index = Grid.get_address_below_index(tile_index)
	# return true if there's a tile under it
	return grid[below_index] != 0
	
func is_current_shape_touching_ground() -> bool:
	if not current_active_shape:
		return false
	return current_active_shape.tiles.any(is_touching_ground)

func get_drop_preview_tiles():
	var tiles = current_active_shape.tiles
	var drop_y = GameConstants.HEIGHT - 1

	# find the value of y when the shape would first be grounded
	for y in range(0, GameConstants.HEIGHT):
		for tile in tiles:
			if is_touching_ground(tile + Vector2i(0, y)):
				drop_y = y
				break
		if drop_y < GameConstants.HEIGHT - 1:
			break
			
	
	return tiles.map(func(t): return t + Vector2i(0, drop_y))

func convert_active_tiles_to_grid():
	for tile in current_active_shape.tiles:
		var tile_index = Grid.v2i_to_index(tile)
		grid[tile_index] = current_active_shape.resource.color
	current_active_shape = null

func generate_new_active_tile_shape():
	current_active_shape = next_active_shape 
	next_active_shape = Shape.new(Vector2i(5, 0), ShapeLibrary.get_random_shape())
	Events.on_new_next_shape.emit()

func can_clear_row(row: int):
	var start_index: int = row * GameConstants.WIDTH
	return range(0, GameConstants.WIDTH).all(func(i): return grid[i + start_index] > 0)
