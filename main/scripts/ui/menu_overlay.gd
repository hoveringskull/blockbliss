class_name MenuOverlay extends Node

signal on_dismiss_loss
signal on_dismiss_highscores

@export var main_menu: MainMenu
@export var high_scores_menu: HighScoresMenu
@export var end_screen: EndScreen

var _music: MusicPlayer
var _game_state_holder: GameStateHolder

func initialize(music: MusicPlayer,\
		sfx: SFXPlayer,\
		high_scores: HighScores,\
		gsh: GameStateHolder) -> void:
	
	_music = music
	_game_state_holder = gsh
			
	main_menu.initialize(music, sfx)
	high_scores_menu.initialize(high_scores)
	end_screen.initialize(high_scores, gsh)
	
	main_menu.request_scores.connect(high_scores_menu.show_menu)
	end_screen.request_dismiss_loss.connect(on_dismiss_loss.emit)
	on_dismiss_highscores.connect(handle_dismiss_highscores)

	update()
	
func handle_dismiss_highscores() -> void:
	high_scores_menu.hide()
	main_menu.show_menu()

func update() -> void:
	if _game_state_holder.game_state and _game_state_holder.game_state.status == GameState.GAME_STATUS.LOST:
		end_screen.show()
		main_menu.hide()
		high_scores_menu.hide()
	else:
		end_screen.hide()
		main_menu.show()
		high_scores_menu.hide()
