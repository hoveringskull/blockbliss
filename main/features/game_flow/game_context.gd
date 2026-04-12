class_name GameContext extends Node

signal on_game_loss

# LOCAL STRUCTURE
@export var renderer: GridRenderer
@export var preview_renderer: PreviewRenderer
@export var overlay: GameOverlay

# PACKED SCENES
@export var shape_library_packed: PackedScene
@export var camera_packed: PackedScene


var _game_controller: GameController
var _grid_controller: GridController
var _score_controller: ScoreController
var _sfx: SFXPlayer
var _music: MusicPlayer
var _shape_lib: ShapeLibrary
var _game_state_holder: GameStateHolder
var _camera: GameCamera

func build_services() -> void:
	_game_controller = GameController.new()
	add_child(_game_controller)
	_grid_controller = GridController.new()
	add_child(_grid_controller)
	_score_controller = ScoreController.new()
	add_child(_score_controller)
	_shape_lib = shape_library_packed.instantiate() as ShapeLibrary
	add_child(_shape_lib)
	
	_camera = camera_packed.instantiate()
	add_child(_camera)
	

func bind_services(sfx: SFXPlayer, music: MusicPlayer, gsh: GameStateHolder) -> void:
	_sfx = sfx
	_music = music
	_game_state_holder = gsh

	_game_controller.bind_services(_score_controller, _grid_controller, gsh, renderer, _sfx, _music)
	_grid_controller.bind_services(gsh, _shape_lib, _sfx)
	_score_controller.bind_services(gsh)
	_camera.initialize()
	
	_grid_controller.on_row_clear.connect(_camera.request_shake_screen.emit)
	_game_controller.on_game_loss.connect(on_game_loss.emit)
	_grid_controller.request_add_score.connect(_score_controller.add_score)
	
	renderer.bind_services(_grid_controller, _game_state_holder)
	preview_renderer.bind_services(_grid_controller, _game_state_holder)
	overlay.initialize(_score_controller, _grid_controller)
		

func handle_start_new_game() -> void:
	_game_state_holder.game_state = GameState.new()
	_game_state_holder.game_state.initialize()
	_game_controller.start()

	renderer.initialize()
	renderer.update()
	
	_score_controller.reset_score()
	_music.play_game_track()
	
	
