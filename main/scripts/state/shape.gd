class_name Shape

var resource: ShapeResource
var offset: Vector2i
var rotation: int # number 0-3 representing 0deg, 90deg, 180deg, 270deg around 0,0 point

const RADS_BY_ROT = [0, 0.5 * PI, PI, 1.5 * PI]

var tiles: Array[Vector2i]:
	get: 
		return get_tiles_with_rot_and_offset(rotation, offset)

func _init(off: Vector2i, res: ShapeResource):
	resource = res
	offset = off

func rotate():
	rotation = (rotation + 1) % 4
	
func get_tiles_with_rot_and_offset(rot: int, off: Vector2i) -> Array[Vector2i]:
	rot = rot % 4
	return Array(resource.tiles.map(func(t): return rotate_tile(t, rot) + off), TYPE_VECTOR2I, "", null)

func rotate_tile(tile: Vector2i, rot: int) -> Vector2i:
	var rads = RADS_BY_ROT[rot]
	return Vector2i(
		roundi(tile.x * cos(rads) - tile.y * sin(rads)),
		roundi(tile.x * sin(rads) + tile.y * cos(rads))
	)
