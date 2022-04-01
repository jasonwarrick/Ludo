extends Node2D

signal player_entered_obstacle

var offsetVal: = 0.0 #Path2D code taken from: https://www.youtube.com/watch?v=jO9adVKegLA
var bushSpeed: = 10
var outOfView: = 1360

var moveFlag = false

func _physics_process(delta):
	if moveFlag:
		$Path2D/PathFollow2D.offset += bushSpeed
		
		if $Path2D/PathFollow2D.offset > outOfView:
			moveFlag = false
			offsetVal = 0.0
			$Path2D/PathFollow2D.offset = 0.0

func _on_Level_move_birds():
	moveFlag = true

func _on_BirdsArea_body_entered(body):
	body.hurt()
	emit_signal("player_entered_obstacle")
