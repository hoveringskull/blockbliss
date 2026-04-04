extends Node

func add_score(amount: int) -> void:
	GameStateHolder.game_state.score += amount
	Events.on_score_updated.emit(GameStateHolder.game_state.score)

func reset_score() -> void:
	GameStateHolder.game_state.score = 0
	Events.on_score_updated.emit(GameStateHolder.game_state.score)
