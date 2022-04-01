extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	SaveLoad.loadData()
	$CanvasLayer/CoinLabel.text = "Coins: " + str(SaveLoad.saveData.coinCount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Game1_pressed():
	get_tree().change_scene("res://FallGame/Level.tscn")


func _on_Game2_pressed():
	get_tree().change_scene("res://RacingGame/Level.tscn")

func _on_Game3_pressed():
	get_tree().change_scene("res://SnowballFight/Level.tscn")
