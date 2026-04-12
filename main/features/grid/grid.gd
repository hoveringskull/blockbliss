class_name Grid

static var Colors: Array[Color] = [
	Color.WHITE,
	Color.hex(0x7776BCFF),
	Color.hex(0xCDC7E8FF),
	Color.hex(0xFFFBDBFF),
	Color.hex(0xFFEC51FF),
	Color.hex(0xFF674DFF),
	Color.hex(0x456990FF),
]

static func index_to_position(i: int) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(i % GameConstants.WIDTH, i / GameConstants.WIDTH) * GameConstants.TILE_SIZE
	
static func address_to_position(v2i: Vector2i) -> Vector2:
	return v2i * GameConstants.TILE_SIZE

static func tile_to_color(t: int) -> Color:
	return Colors[t]

static func get_index_below_index(index: int) -> int:
	return index + GameConstants.WIDTH

static func index_to_v2i(i: int) -> Vector2i:
	@warning_ignore("integer_division")
	return Vector2i(i % GameConstants.WIDTH, i / GameConstants.WIDTH)

static func v2i_to_index(v2i: Vector2i) -> int:
	return v2i.y * GameConstants.WIDTH + v2i.x
