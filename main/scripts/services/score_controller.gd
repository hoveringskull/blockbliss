class_name ScoreController extends Node

var _game_state_holder: GameStateHolder 

func bind_services(game_state_holder: GameStateHolder) -> void:
	_game_state_holder = game_state_holder

func add_score(amount: int) -> void:
	_game_state_holder.game_state.score += amount
	Events.on_score_updated.emit(_game_state_holder.game_state.score)

func reset_score() -> void:
	_game_state_holder.game_state.score = 0
	Events.on_score_updated.emit(_game_state_holder.game_state.score)
