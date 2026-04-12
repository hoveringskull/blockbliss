# GdUnit generated TestSuite
class_name GridRendererTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://features/grid/grid_renderer.gd'

var mocked_gsh: GameStateHolder
var mocked_grid_controller: GridController

var grid_renderer: GridRenderer

var runner: GdUnitSceneRunner

func before_test() -> void:	
	grid_renderer = auto_free(GridRenderer.new())
	
	mocked_gsh = mock(GameStateHolder)
	mocked_grid_controller = mock(GridController)
	
	do_return(GameState.new()).on(mocked_gsh).get_state()

	grid_renderer.bind_services(mocked_grid_controller, mocked_gsh)

func test_draw_grid() -> void:	
	# ACT
	grid_renderer.draw_grid()
	
	# ASSERT
	assert_int(grid_renderer.get_child_count()).is_equal(GameConstants.TILE_COUNT)
