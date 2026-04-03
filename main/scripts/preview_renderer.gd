extends Node2D
var preview_renderer_tile = preload("res://scenes/preview_renderer.tscn")

var game_state: GameState:
	get: return GameStateHolder.game_state

func _ready():
	position = Vector2((get_window().size.x / 2.0) - (GameConstants.WIDTH * GameConstants.TILE_SIZE / 2.0), GameConstants.TILE_SIZE / 2.0)

func _process(_delta):
	clear()
	if game_state and game_state.current_active_shape:
		render()
	

func render():
	# todo: maybe update movement rahter than clear and rerender for performance
	for tile_address in game_state.get_drop_preview_tiles():
		var preview_tile = preview_renderer_tile.instantiate()
		add_child(preview_tile)
		preview_tile.position = Grid.address_to_position(tile_address)

func clear():
	for child in get_children():
		child.queue_free()
