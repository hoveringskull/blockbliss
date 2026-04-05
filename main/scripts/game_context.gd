class_name GameContext extends Node

var _game_controller: GameController
var _grid_controller: GridController
var _score_controller: ScoreController
var _sfx: SFXPlayer
var _music: MusicPlayer
var _shape_lib: ShapeLibrary

@export var renderer: GridRenderer
@export var preview_renderer: PreviewRenderer
@export var shape_library_packed: PackedScene

func build_services() -> void:
	_game_controller = GameController.new()
	add_child(_game_controller)
	_grid_controller = GridController.new()
	add_child(_grid_controller)
	_score_controller = ScoreController.new()
	add_child(_score_controller)
	_shape_lib = shape_library_packed.instantiate() as ShapeLibrary
	add_child(_shape_lib)

func bind_services(sfx: SFXPlayer, music: MusicPlayer) -> void:
	_sfx = sfx
	_music = music
	_game_controller.bind_services(_score_controller, _grid_controller, GameStateHolder, renderer, _sfx, _music)
	_grid_controller.bind_services(_score_controller, GameStateHolder, _shape_lib, _sfx)
	_score_controller.bind_services(GameStateHolder)
	
	renderer.bind_services(_grid_controller)
	preview_renderer.bind_services(_grid_controller)

func handle_start_new_game() -> void:
	GameStateHolder.game_state = GameState.new()
	_game_controller.initialize()
	_game_controller.start()

	renderer.initialize()
	renderer.update()
	
	
