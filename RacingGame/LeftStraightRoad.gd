extends Node2D

var prev: int = 0 # 0 is left, 1 is middle, 2 is right
export var next: int = 1

func get_next():
	return next
