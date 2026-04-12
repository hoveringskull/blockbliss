class_name GameStateHolder extends Node

var game_state: GameState

func get_state() -> GameState:
	return game_state

func clear() -> void:
	game_state = null
