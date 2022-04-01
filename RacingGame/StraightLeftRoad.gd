extends Node2D

var prev: int = 1 # 0 is left, 1 is middle, 2 is right
export var next: int = 0

var rng = RandomNumberGenerator.new()

func cacti():
	pass

func get_next():
	return next
