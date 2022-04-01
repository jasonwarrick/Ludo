extends Node2D

func show():
	self.visible = true

func hide():
	self.visible = false

func _ready():
	randomize()

func pickup():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	SaveLoad.coins += 1
	$SFX/Pickup1.playing = true

func _on_CoinArea_body_entered(body):
	pickup()
	hide()

func _on_Coin_hide_coins():
	hide()

func _on_Coin_reset_coins():
	show()


func _on_StraightRoad_flip_coin():
	self.visible = !self.visible
