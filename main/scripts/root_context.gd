class_name RootContext extends Node

@export var menu_scene_packed: PackedScene
@export var game_scene_packed: PackedScene
@export var music_player_packed: PackedScene
@export var sfx_player_packed: PackedScene

var _sfx: SFXPlayer
var _music: MusicPlayer
var _game_state_holder: GameStateHolder

var current_scene: Node

func _ready() -> void:
	build_services()
	bind_services()
	go_to_menu()


func build_services() -> void:
	_sfx = sfx_player_packed.instantiate() as SFXPlayer
	add_child(_sfx)
	_music = music_player_packed.instantiate() as MusicPlayer
	add_child(_music)
	_game_state_holder = GameStateHolder.new()
	add_child(_game_state_holder)
	
func bind_services() -> void:
	return

func go_to_menu() -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = menu_scene_packed.instantiate()
	add_child(current_scene)

	var menu_scene: MenuContext = current_scene as MenuContext
	if menu_scene:
		menu_scene.build_services()
		menu_scene.bind_services(_sfx, _music, _game_state_holder)
		menu_scene.connect_signals()
		menu_scene.setup()
		
		menu_scene.request_quit.connect(handle_request_quit)
		menu_scene.request_start_game.connect(handle_request_start_game)
		
	
func handle_request_start_game() -> void:
	if current_scene:
		current_scene.queue_free()
	current_scene = game_scene_packed.instantiate()
	add_child(current_scene)
	
	# TODO: start playing game music!
	
	var game_scene: GameContext = current_scene as GameContext
	if game_scene:
		game_scene.build_services()
		game_scene.bind_services(_sfx, _music, _game_state_holder)
		game_scene.handle_start_new_game()
		
		game_scene.on_game_loss.connect(handle_loss)

func handle_request_quit() -> void:
	get_tree().quit()
	
func handle_loss() -> void:
	go_to_menu()
