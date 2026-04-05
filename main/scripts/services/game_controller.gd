class_name GameController extends Node

var _score_controller: ScoreController
var _grid_controller: GridController
var _game_state_holder: GameStateHolder
var _renderer: GridRenderer
var _sfx: SFXPlayer
var _music: MusicPlayer

var state: GameState:
	get: return _game_state_holder.game_state

var has_emitted_loss: bool = false


func bind_services(score_controller: ScoreController,\
		grid_controller: GridController,\
		game_state_holder: GameStateHolder,\
		renderer: GridRenderer,
		sfx: SFXPlayer,
		music: MusicPlayer) -> void:
	_score_controller = score_controller
	_grid_controller = grid_controller
	_game_state_holder = game_state_holder
	_renderer = renderer
	_sfx = sfx
	_music = music
	

func initialize() -> void:
	# set up initial conditions
	state.active_time = 0
	state.last_drop_time = 0
	state.current_active_shape = null
	state.next_active_shape = null
	state.grid.resize(GameConstants.TILE_COUNT)
	state.grid.fill(GameConstants.TILE.NONE)
	

func start() -> void:
	_score_controller.reset_score()
	state.status = GameState.GAME_STATUS.ACTIVE
	_grid_controller.generate_new_active_tile_shape()
	_grid_controller.generate_new_active_tile_shape() # Generates a second so we have one in the queue

func toggle_pause() -> void:
	if state.status == GameState.GAME_STATUS.PAUSED:
		state.status = state.last_status
	else:
		state.last_status = state.status
		state.status = GameState.GAME_STATUS.PAUSED


func update_game_state() -> void:
	# check if any grid tiles are in the top row and lose if so
	for i: int in range(GameConstants.WIDTH):
		if state.grid[i] != 0:
			state.status = GameState.GAME_STATUS.LOST

func _process(delta: float) -> void:
	if state:
		if Input.is_action_just_pressed("pause"):
			toggle_pause()
		
		if state.status == GameState.GAME_STATUS.ACTIVE:
			state.active_time += delta
			if state.active_time - state.last_drop_time > state.total_gravity:
				# drop current dropping tiles
				state.last_drop_time = state.active_time
				if state.current_active_shape:
					if _grid_controller.is_current_shape_touching_ground():
						@warning_ignore("unsafe_method_access")
						_sfx.request_sound(SFXPlayer.Key.IMPACT)
						_grid_controller.convert_active_tiles_to_grid()
						_grid_controller.check_and_clear_rows()
						update_game_state()
						_grid_controller.generate_new_active_tile_shape()
					else:
						state.current_active_shape.offset += Vector2i(0, 1)
			
			# todo: allow holding down
			if Input.is_action_pressed("right"):
				_grid_controller.move_active_blocks(Vector2i(1, 0))
			elif Input.is_action_pressed("left"):
				_grid_controller.move_active_blocks(Vector2i(-1, 0))

			if Input.is_action_pressed("down"):
				state.speed_up = true
			else:
				state.speed_up = false

			if Input.is_action_just_pressed("up"):
				_grid_controller.rotate_active_blocks()

			# TODO: Maybe clean up this dependency later?
			_renderer.update()
		elif state.status == GameState.GAME_STATUS.LOST and has_emitted_loss == false:
			Events.on_game_lost.emit()
			_music.play_loss_track()
			has_emitted_loss = true
