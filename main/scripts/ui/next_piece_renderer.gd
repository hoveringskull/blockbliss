class_name NextPieceRenderer extends PanelContainer

@export var piece_frame: Control
@export var empty_cell_sprite: Texture2D
@export var tile_sprite: Texture2D

var _game_state_holder: GameStateHolder
var _grid_controller: GridController

var game_state: GameState:
	get:
		return _game_state_holder.game_state

const WIDTH: int = 5
const HEIGHT: int = 5
const OFFSET: int = 2
const FRAME_OFFSET: Vector2 = Vector2(16, 0)

func initialize(gsh: GameStateHolder, grid_controller: GridController) -> void:
	bind_services(gsh, grid_controller)
	bind_listeners()

func bind_services(gsh: GameStateHolder, grid_controller: GridController) -> void:
	_game_state_holder = gsh	
	_grid_controller = grid_controller

func bind_listeners() -> void:
	_grid_controller.on_new_next_shape.connect(render_next_piece)

func render_next_piece() -> void:
	clear()
	if not game_state:
		return

	var piece: Shape = game_state.next_active_shape

	if not piece:
		return

	for x: int in range(WIDTH):
		for y: int in range(HEIGHT):
				var cell: Sprite2D = Sprite2D.new()
				piece_frame.add_child(cell)
				cell.position = (Vector2(x, y) * GameConstants.TILE_SIZE) + Vector2(0, 0.5 * GameConstants.TILE_SIZE) + FRAME_OFFSET
				
				if shape_has_tile_at_position(piece, x - OFFSET, y - OFFSET):
					cell.texture = tile_sprite
					cell.modulate = Grid.tile_to_color(piece.resource.color)
				else:
					cell.texture = empty_cell_sprite

func shape_has_tile_at_position(piece: Shape, x: int, y: int) -> bool:
	return piece.resource.offsets.any(func(t: Vector2i) -> bool: return t.x == x and t.y == y)

func clear() -> void:
	for child: Node in piece_frame.get_children():
		child.queue_free()
