# GdUnit generated TestSuite
class_name GridTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://features/grid/grid.gd'


func test_index_to_position(index: int, expected: Vector2, _test_parameters := [
	[0, Vector2.ZERO],
	[1, Vector2(32, 0)],
	[2, Vector2(64, 0)],
	[10, Vector2(0, 32)],
	[11, Vector2(32, 32)]
]) -> void:
	assert_vector(Grid.index_to_position(index)).is_equal(expected)
	
func test_address_to_position(address: Vector2i, expected: Vector2, _test_paramters := [
	[Vector2i.ZERO, Vector2.ZERO],
	[Vector2i(1, 0), Vector2(32, 0)],
	[Vector2i(2, 0), Vector2(64, 0)],
	[Vector2i(0, 1), Vector2(0, 32)],
	[Vector2i(1, 1), Vector2(32, 32)],
]) -> void:
	assert_vector(Grid.address_to_position(address)).is_equal(expected)

func test_tile_to_color() -> void:
	assert_object(Grid.tile_to_color(0)).is_equal(Color.WHITE)
	assert_object(Grid.tile_to_color(1)).is_equal(Color.hex(0x7776BCFF))
	
func test_get_index_below_index() -> void:
	assert_int(Grid.get_index_below_index(0)).is_equal(10)
	assert_int(Grid.get_index_below_index(1)).is_equal(11)
	
func test_index_to_v2i(index: int, expected: Vector2i, _test_parameters := [
	[0, Vector2i.ZERO],
	[1, Vector2i(1, 0)],
	[10, Vector2i(0, 1)],
	[11, Vector2i(1, 1)],
]) -> void:
	assert_vector(Grid.index_to_v2i(index)).is_equal(expected)
	
func test_v2i_to_index(address: Vector2i, expected: int, _test_parameters := [
	[Vector2i.ZERO, 0],
	[Vector2i(1, 0), 1],
	[Vector2i(0, 1), 10],
	[Vector2i(1, 1), 11],
]) -> void:
	assert_int(Grid.v2i_to_index(address)).is_equal(expected)
