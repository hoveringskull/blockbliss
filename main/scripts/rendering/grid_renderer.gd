class_name GridRenderer extends Node2D

var tile_renderer_scene: PackedScene = preload("res://scenes/block_renderer.tscn")
var grid_cell_renderer_scene: PackedScene = preload("res://scenes/grid_cell_renderer.tscn")
var destroy_tile_renderer_particles: PackedScene = preload("res://scenes/destroy_particles.tscn")

var rendered_tile_renderers: Array[Sprite2D]
var dropping_tile_renderers: Array[Sprite2D]

var _grid_controller: GridController

var game_state: GameState:
	get: return GameStateHolder.game_state

func _ready() -> void:
	Events.on_row_clear.connect(generate_clear_particles)

func bind_services(grid_controller: GridController) -> void:
	_grid_controller = grid_controller

func initialize() -> void:
	position = Vector2((get_window().size.x / 2.0) - (GameConstants.WIDTH * GameConstants.TILE_SIZE / 2.0), GameConstants.TILE_SIZE / 2.0)
	rendered_tile_renderers.resize(GameConstants.TILE_COUNT)
	draw_grid()
	
func clear_grid() -> void:
	for child: Node in get_children():
		child.queue_free()
	
	for tile_renderer: Sprite2D in rendered_tile_renderers:
		if tile_renderer:
			tile_renderer.queue_free()
	
	for tile_renderer: Sprite2D in dropping_tile_renderers:
		if tile_renderer:
			tile_renderer.queue_free()
	dropping_tile_renderers = []

func draw_grid() -> void:
	clear_grid()
	for x: int in range(0, GameConstants.WIDTH):
		for y: int in range(0, GameConstants.HEIGHT):
			var cell: Node2D = grid_cell_renderer_scene.instantiate()
			add_child(cell)
			cell.position = Grid.address_to_position(Vector2i(x, y))
			

func generate_clear_particles(row: int, values: Array[int]) -> void:
	for i: int in range(GameConstants.WIDTH):
		# render particles
		var particles: GPUParticles2D = destroy_tile_renderer_particles.instantiate()
		add_child(particles)
		particles.emitting = true
		particles.position = Grid.index_to_position(row * GameConstants.WIDTH + i)
		particles.modulate = Grid.tile_to_color(values[i])
		particles.finished.connect(particles.queue_free)

func update() -> void:
	# checks all rendered tiles; if a tile does not need to be changed, ignores it.
	# otherwise, removes, recolors, or creates it
	
	if game_state.current_active_shape:
		var percentage_of_next_row_dropped: float = (game_state.active_time - game_state.last_drop_time) / game_state.total_gravity 
		var grounded: bool = _grid_controller.is_current_shape_touching_ground()
		
		# create new dropping tile_renderers
		if dropping_tile_renderers.size() != game_state.current_active_shape.tiles.size():
			for dropping_tile_renderer: Sprite2D in dropping_tile_renderers:
				dropping_tile_renderer.queue_free()
			dropping_tile_renderers = []
			for tile: Vector2i in game_state.current_active_shape.tiles:
				var tile_renderer: Sprite2D = tile_renderer_scene.instantiate()
				add_child(tile_renderer)
				dropping_tile_renderers.append(tile_renderer)
		
		# update dropping tile_renderers
		for tile_index: int in range(0, game_state.current_active_shape.tiles.size()):
			var dropping_tile_renderer: Sprite2D = dropping_tile_renderers[tile_index]
			var color: Color = Grid.tile_to_color(game_state.current_active_shape.resource.color)
			
			if dropping_tile_renderer:
				dropping_tile_renderer.position = Grid.address_to_position(game_state.current_active_shape.tiles[tile_index])\
					+ Vector2(0.0, 0.0 if grounded else percentage_of_next_row_dropped * GameConstants.TILE_SIZE)
				dropping_tile_renderer.modulate = color

	# TODO: optimize this by only covering changed indices, maybe?
	for i: int in range(GameConstants.TILE_COUNT):
		var rendered_tile_renderer: Sprite2D = rendered_tile_renderers[i]
		var value: int = game_state.grid[i]
		if !rendered_tile_renderer and value > 0:
			# create tile_renderer
			var tile_renderer: Sprite2D = tile_renderer_scene.instantiate()
			add_child(tile_renderer)
			rendered_tile_renderers[i] = tile_renderer
			tile_renderer.position = Grid.index_to_position(i)
			tile_renderer.modulate = Grid.tile_to_color(value)
		elif rendered_tile_renderer and value ==  0:
			# destroy tile_renderer
			rendered_tile_renderer.queue_free()
		elif rendered_tile_renderer and rendered_tile_renderer.modulate != Grid.tile_to_color(value):
			# recolor tile_renderer
			rendered_tile_renderer.modulate = Grid.tile_to_color(value)
