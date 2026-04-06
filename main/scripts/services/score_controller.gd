class_name ScoreController extends Node

signal on_score_updated

var _game_state_holder: GameStateHolder 

func bind_services(game_state_holder: GameStateHolder) -> void:
	_game_state_holder = game_state_holder

func add_score(amount: int) -> void:
	_game_state_holder.game_state.score += amount
	on_score_updated.emit(_game_state_holder.game_state.score)

func reset_score() -> void:
	_game_state_holder.game_state.score = 0
	on_score_updated.emit(_game_state_holder.game_state.score)
