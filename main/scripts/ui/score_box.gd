class_name ScoreBox extends PanelContainer

var _game_state_holder: GameStateHolder
var _score_controller: ScoreController

@export 
var score_display_label: Label

func initialize(gsh: GameStateHolder, score_controller: ScoreController) -> void:
	bind_services(gsh, score_controller)
	bind_events()
	if _game_state_holder.game_state:
		update_score(_game_state_holder.game_state.score)


func bind_services(gsh: GameStateHolder, score_controller) -> void:
	_game_state_holder = gsh
	_score_controller = score_controller

	
func bind_events() -> void:
	_score_controller.on_score_updated.connect(update_score)

func update_score(value: int) -> void:
	score_display_label.text = str(value).lpad(8, "0")
