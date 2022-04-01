extends Node2D

signal move_rock
signal move_birds
signal move_bush
signal move_rock_coins
signal move_bush_coins
signal move_bird_coins

var obstacleRng = RandomNumberGenerator.new()
var obstacleInt = RandomNumberGenerator.new()
var sendFlag: = false
var spawnGap: = 3.0
var score: = 0
var health: = 3

func set_timer():
	obstacleRng.randomize()
	$ObstacleTimer.wait_time = obstacleRng.randf_range(0.75, spawnGap)
	$ObstacleTimer.start()

func show_health():
	match health:
		0: 
			$CanvasLayer/VBoxContainer/HBoxContainer/Container1/Heart1.set_animation("Empty")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container2/Heart2.set_animation("Empty")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container3/Heart3.set_animation("Empty")
			$EndTimer.start()
			$ScoreTimer.stop()
		1:
			$CanvasLayer/VBoxContainer/HBoxContainer/Container1/Heart1.set_animation("Full")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container2/Heart2.set_animation("Empty")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container3/Heart3.set_animation("Empty")
		2:
			$CanvasLayer/VBoxContainer/HBoxContainer/Container1/Heart1.set_animation("Full")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container2/Heart2.set_animation("Full")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container3/Heart3.set_animation("Empty")
		3:
			$CanvasLayer/VBoxContainer/HBoxContainer/Container1/Heart1.set_animation("Full")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container2/Heart2.set_animation("Full")
			$CanvasLayer/VBoxContainer/HBoxContainer/Container3/Heart3.set_animation("Full")
		_:
			pass

func _ready():
	$FallGuy.set_collision_layer_bit(4, true)
	SaveLoad.coins = 0
	$Coin.moveMode = 0
	$Coin2.moveMode = 1
	$Coin3.moveMode = 2
	sendFlag = true
	set_timer()
	$ScoreTimer.start()
	$GapTimer.start()

func _process(delta):
	$CanvasLayer/VBoxContainer/ScoreLabel.text = str(score)
	$CanvasLayer/CoinsLabel.text = str(SaveLoad.coins)

func _on_ObstacleTimer_timeout():
	obstacleInt.randomize()
	var randInt = obstacleInt.randi_range(0, 2)
	if randInt == 0:
		$FallGuy.set_collision_layer_bit(4, false)
		emit_signal("move_rock")
		emit_signal("move_rock_coins")
	elif (randInt == 1):
		emit_signal("move_birds")
		emit_signal("move_bird_coins")
	else:
		emit_signal("move_bush")
		emit_signal("move_bush_coins")
	
	if sendFlag:
		set_timer()

func _on_player_entered_obstacle():
	health -= 1
	show_health()


func _on_ScoreTimer_timeout():
	score += 1


func _on_EndTimer_timeout():
	get_tree().change_scene("res://MainMenu.tscn")
	SaveLoad.saveData()


func _on_GapTimer_timeout():
	var newGap = spawnGap - 0.15
	if newGap > 1.0:
		spawnGap = newGap
