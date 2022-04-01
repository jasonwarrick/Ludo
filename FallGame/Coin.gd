extends Node2D

var offsetVal: = 0.0 #Path2D code taken from: https://www.youtube.com/watch?v=jO9adVKegLA
var bushSpeed: = 10
var outOfView: = 1440
var moveMode: = 0

signal hide_coins
signal reset_coins

var moveFlag = false

func _physics_process(delta):
	if moveFlag and moveMode == 0:
		$Path2D/RockFollow.offset += bushSpeed
		
		if $Path2D/RockFollow.offset > outOfView:
#			emit_signal("hide_coins")
			show_rock_coins(false)
			moveFlag = false
			offsetVal = 0.0
			$Path2D/RockFollow.offset = 0.0
	
	elif moveFlag and moveMode == 1:
		$Path2D/BushFollow.offset += bushSpeed
		
		if $Path2D/BushFollow.offset > outOfView:
#			emit_signal("hide_coins")
			show_bush_coins(false)
			moveFlag = false
			offsetVal = 0.0
			$Path2D/BushFollow.offset = 0.0
	
	elif moveFlag and moveMode == 2:
		$Path2D/BirdFollow.offset += bushSpeed
		
		if $Path2D/BirdFollow.offset > outOfView:
			print("test stop")
#			emit_signal("hide_coins")
			show_bird_coins(false)
			moveFlag = false
			offsetVal = 0.0
			$Path2D/BirdFollow.offset = 0.0

func hide_coins():
	for member in get_tree().get_nodes_in_group("Coins"): #loop taken from godotengine.org/qa/30943/is-it-possible-to-get-all-the-members-of-a-group
		member.hide()

func show_rock_coins(flag):
	for member in get_tree().get_nodes_in_group("Rock_Coins"): #loop taken from godotengine.org/qa/30943/is-it-possible-to-get-all-the-members-of-a-group
		if flag:
			member.show()
		else:
			member.hide()

func show_bush_coins(flag):
	for member in get_tree().get_nodes_in_group("Bush_Coins"): #loop taken from godotengine.org/qa/30943/is-it-possible-to-get-all-the-members-of-a-group
		if flag:
			member.show()
		else:
			member.hide()

func show_bird_coins(flag):
	for member in get_tree().get_nodes_in_group("Bird_Coins"): #loop taken from godotengine.org/qa/30943/is-it-possible-to-get-all-the-members-of-a-group
		if flag:
			member.show()
		else:
			member.hide()


func _ready():
#	emit_signal("hide_coins")
	hide_coins()
	$Path2D/RockFollow.offset = 0.0
	$Path2D/BushFollow.offset = 0.0
	$Path2D/BirdFollow.offset = 0.0
	
	$Path2D/RockFollow.visible = false
	$Path2D/BushFollow.visible = false
	$Path2D/BirdFollow.visible = false

func _on_Level_move_rock_coins():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if $Path2D/RockFollow.offset == 0.0 and moveMode == 0 and rng.randi_range(0,2) == 1:
		$Path2D/RockFollow.visible = true
		$Path2D/BushFollow.visible = false
		$Path2D/BirdFollow.visible = false
#		emit_signal("reset_coins")
		show_rock_coins(true)
		moveFlag = true

func _on_Level_move_bush_coins():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if $Path2D/BushFollow.offset == 0.0 and moveMode == 1 and rng.randi_range(0,2) == 1:
		$Path2D/RockFollow.visible = false
		$Path2D/BushFollow.visible = true
		$Path2D/BirdFollow.visible = false
#		emit_signal("reset_coins")
		show_bush_coins(true)
		moveFlag = true

func _on_Level_move_bird_coins():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	if $Path2D/BirdFollow.offset == 0.0 and moveMode == 2 and rng.randi_range(0,2) == 1:
		$Path2D/RockFollow.visible = false
		$Path2D/BushFollow.visible = false
		$Path2D/BirdFollow.visible = true
#		emit_signal("reset_coins")
		show_bird_coins(true)
		moveFlag = true
