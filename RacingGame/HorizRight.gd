extends Node2D

var prev: int = 2 # 0 is left, 1 is middle, 2 is right
export var next: int = 2

var rng = RandomNumberGenerator.new()

func get_next():
	return next
