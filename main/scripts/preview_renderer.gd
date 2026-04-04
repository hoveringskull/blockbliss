extends Node2D
var preview_renderer_tile: PackedScene = preload("res://scenes/preview_renderer.tscn")

var game_state: GameState:
	get: return GameStateHolder.game_state

func _ready() -> void:
	position = Vector2((get_window().size.x / 2.0) - (GameConstants.WIDTH * GameConstants.TILE_SIZE / 2.0), GameConstants.TILE_SIZE / 2.0)

func _process(_delta: float) -> void:
	clear()
	if game_state and game_state.current_active_shape:
		render()
	

func render() -> void:
	# todo: maybe update movement rahter than clear and rerender for performance
	for tile_address: Vector2i in GridController.get_drop_preview_tiles():
		var preview_tile: Sprite2D = preview_renderer_tile.instantiate()
		add_child(preview_tile)
		preview_tile.position = Grid.address_to_position(tile_address)

func clear() -> void:
	for child: Node in get_children():
		child.queue_free()
