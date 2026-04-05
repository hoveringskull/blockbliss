class_name EndScreen extends PanelContainer

const MAX_NAME_INPUT: int = 10

@export var dismiss_button: Button
@export var score: Label
@export var name_input: LineEdit

var _high_scores: HighScores


func initialize(high_scores: HighScores) -> void:
	bind_events()
	bind_services(high_scores)
	hide()

func bind_services(high_scores: HighScores) -> void:
	_high_scores = high_scores

func bind_events() -> void:
	Events.on_game_lost.connect(handle_game_lost)
	
	dismiss_button.pressed.connect(dismiss_loss)
	
func handle_game_lost() -> void:
	visible = true
	score.text = str(GameStateHolder.game_state.score)

func dismiss_loss() -> void:
	visible = false
	_high_scores.add_score(HighScore.new(name_input.text.substr(0, MAX_NAME_INPUT), GameStateHolder.game_state.score))
	Events.request_dismiss_loss.emit()
