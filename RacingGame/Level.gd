extends Node2D

const StraightRoad = preload("res://RacingGame/StraightRoad.tscn")
const StraightRightRoad = preload("res://RacingGame/StraightRightRoad.tscn")
const StraightLeftRoad = preload("res://RacingGame/StraightLeftRoad.tscn")

var straight = [preload("res://RacingGame/StraightRoad.tscn"), preload("res://RacingGame/StraightRightRoad.tscn"), preload("res://RacingGame/StraightLeftRoad.tscn")]
var left = [preload("res://RacingGame/HorizLeft.tscn"), preload("res://RacingGame/LeftStraightRoad.tscn")]
var right = [preload("res://RacingGame/HorizRight.tscn"), preload("res://RacingGame/RightStraightRoad.tscn")]

var scoreArea = preload("res://RacingGame/ScoreArea.tscn")

const gasCan = preload("res://RacingGame/GasCan.tscn")

const coin = preload("res://RacingGame/SingleCoin.tscn")
var coin_rng = RandomNumberGenerator.new()

onready var rootRoad = get_node("Roads/StraightRoad")

var rng = RandomNumberGenerator.new()
var gas_rng = RandomNumberGenerator.new()
var gasLocation: int
var gasLow: int = 12
var gasHigh: int = 17
var gasCounter: int = 0
var maxDifficulty: int = 8

var direction: int = 1

var roadLimit: int = 500
var placeArea: bool = false
var areaCounter: int = 0

func _ready():
	$Roads/StraightRoad.cacti()
	$Car/MainTheme.playing = true
	reset_gas()
	road_loop()

func reset_gas():
	gas_rng.randomize()
	gasLocation = gas_rng.randi_range(gasLow, gasHigh)
	if gasCounter <= maxDifficulty:
		gasLow += 1
		gasHigh += 1
		gasCounter += 1

func road_loop():
	for i in roadLimit:
		generate_road()

func _physics_process(delta):
	$CanvasLayer/GasBar.value = round($Car.gas)
	$CanvasLayer/HealthBar.value = float($Car.health)
	$CanvasLayer/ScoreLabel.text = "Score: " + str($Car.score)
#	$CanvasLayer/Label3.text = str($Car.health)
#	$CanvasLayer/Label2.text = str($Car.gas)

func generate_road():
	areaCounter += 1
	rng.randomize()
	var selection: int
	var newRoadInstance: Node2D
	var newScoreInstance: Node2D
	
	match direction:
		0:
			selection = rng.randi_range(0, left.size() - 1)
			newRoadInstance = left[selection].instance()
		1:
			selection = rng.randi_range(0, straight.size() - 1)
			newRoadInstance = straight[selection].instance()
			newRoadInstance.cacti()
		2:
			selection = rng.randi_range(0, right.size() - 1)
			newRoadInstance = right[selection].instance()
	newRoadInstance.add_to_group("Roads")
	newScoreInstance = scoreArea.instance()
	direction = newRoadInstance.next
	
	if areaCounter == gasLocation:
		var gasInstance = gasCan.instance()
		gasInstance.position = rootRoad.get_node("Good").get_global_transform().origin
		gasInstance.z_index = 2
		$GasCans.add_child(gasInstance)
		reset_gas()
		areaCounter = 0
	
	newScoreInstance.position = rootRoad.get_node("Good").get_global_transform().origin
	newRoadInstance.position = rootRoad.get_node("Good").get_global_transform().origin #.position + Vector2(0,(256))
	coin_rng.randomize()
	if coin_rng.randi_range(1, 2) == 1:
		var coin_instance = coin.instance()
		coin_instance.position = rootRoad.get_node("Good").get_global_transform().origin
		self.add_child(coin_instance)
	$Roads.add_child(newRoadInstance)
	self.add_child(newScoreInstance)
	rootRoad = newRoadInstance

func _on_Area2D_body_entered(body):
	road_loop()


func _on_game_over():
	get_tree().change_scene("res://MainMenu.tscn")
