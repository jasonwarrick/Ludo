extends Node
#test
var coins = 0 setget set_coins, get_coins

func set_coins(value):
	coins += 1

func get_coins():
	return coins
