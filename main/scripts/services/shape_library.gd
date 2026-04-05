class_name ShapeLibrary extends Node

@export
var shapes: Array[ShapeResource]

func get_random_shape() -> ShapeResource:
	return shapes.pick_random()
