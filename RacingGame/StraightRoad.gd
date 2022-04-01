extends Node2D

var prev: int = 1 # 0 is left, 1 is middle, 2 is right
export var next: int = 1

const coin = preload("res://RacingGame/SingleCoin.tscn")
const cactus = preload("res://RacingGame/Cactus.tscn")

var rng = RandomNumberGenerator.new()

signal flip_coin

#func _ready():
#	cacti()

func cacti():
	rng.randomize()
	var chance = rng.randi_range(1, 3)
	var left = $Left/CollisionShape2D
	var right = $Right/CollisionShape2D
	var width = $Left/CollisionShape2D.get_shape().get_extents().x
	var height = $Left/CollisionShape2D.get_shape().get_extents().y
	var cactus_inst = cactus.instance()
	match chance:
		1:
			cactus_inst.position.x = (left.global_position.x + rng.randi_range(-width, width))
			cactus_inst.position.y = (left.global_position.y + rng.randi_range(-height, height))# + rng.randi_range(0, height)
			cactus_inst.rotation_degrees = rng.randi_range(0,359)
			self.add_child(cactus_inst)
		2:
			cactus_inst.position.x = (right.global_position.x + (width * 2) + rng.randi_range(-width, width))
			cactus_inst.position.y = (right.global_position.y + rng.randi_range(-height, height))
			cactus_inst.rotation_degrees = rng.randi_range(0,359)
			self.add_child(cactus_inst)
		3:
			pass

func get_next():
	return next
