class_name EndScreen extends PanelContainer

signal request_dismiss_loss

const MAX_NAME_INPUT: int = 10

@export var dismiss_button: Button
@export var score: Label
@export var name_input: LineEdit

var _high_scores: HighScores
var _game_state_holder: GameStateHolder


func initialize(high_scores: HighScores, gsh: GameStateHolder) -> void:
	bind_services(high_scores, gsh)
	bind_events()
	hide()

func bind_services(high_scores: HighScores, gsh: GameStateHolder) -> void:
	_high_scores = high_scores
	_game_state_holder = gsh

func bind_events() -> void:	
	dismiss_button.pressed.connect(dismiss_loss)
	
func handle_game_lost() -> void:
	visible = true
	score.text = str(_game_state_holder.game_state.score)

func dismiss_loss() -> void:
	visible = false
	_high_scores.add_score(HighScore.new(name_input.text.substr(0, MAX_NAME_INPUT), _game_state_holder.game_state.score))
	request_dismiss_loss.emit()
