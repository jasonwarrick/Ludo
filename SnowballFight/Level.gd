extends Spatial

onready var enemy_1 = preload("res://SnowballFight/Enemy.tscn")
onready var enemy_2 = preload("res://SnowballFight/Enemy.tscn")
onready var enemy_3 = preload("res://SnowballFight/Enemy.tscn")

var enemyType: = 1

var enemies_alive: = 0

onready var player = $Player

signal red_spawned
signal green_spawned
signal yellow_spawned

var resetting: bool = false

var rng = RandomNumberGenerator.new()

var snowballs

func _ready():
	set_timer()

func set_timer():
	rng.randomize()
	var newType = rng.randi_range(1, 4)
	while newType == enemyType:
		newType = rng.randi_range(1, 4)
	enemyType = newType
	rng.randomize()
	if $EnemyTimer.time_left == 0 and enemies_alive < 5:
			$EnemyTimer.wait_time = rng.randf_range(1.5, 4.0)
			$EnemyTimer.start()
	else:
			return

func _process(delta):
	$CanvasLayer/Score.text = "Score: " + str(player.score)
	snowballs = player.snowballs
	if enemies_alive <= 1:
		set_timer()
	match player.health:
		0:
			$CanvasLayer/Health/h1.set_animation("empty")
			$CanvasLayer/Health/h2.set_animation("empty")
			$CanvasLayer/Health/h3.set_animation("empty")
			if not resetting:
				$ResetTimer.start()
				resetting = true
		1:
			$CanvasLayer/Health/h1.set_animation("full")
			$CanvasLayer/Health/h2.set_animation("empty")
			$CanvasLayer/Health/h3.set_animation("empty")
		2:
			$CanvasLayer/Health/h1.set_animation("full")
			$CanvasLayer/Health/h2.set_animation("full")
			$CanvasLayer/Health/h3.set_animation("empty")
		3:
			$CanvasLayer/Health/h1.set_animation("full")
			$CanvasLayer/Health/h2.set_animation("full")
			$CanvasLayer/Health/h3.set_animation("full")
	match snowballs:
		0:
			$CanvasLayer/Snowballs/ball1.visible = false
			$CanvasLayer/Snowballs/ball2.visible = false
			$CanvasLayer/Snowballs/ball3.visible = false
			$CanvasLayer/Snowballs/ball4.visible = false
			$CanvasLayer/Snowballs/ball5.visible = false
		1:
			$CanvasLayer/Snowballs/ball1.visible = true
			$CanvasLayer/Snowballs/ball2.visible = false
			$CanvasLayer/Snowballs/ball3.visible = false
			$CanvasLayer/Snowballs/ball4.visible = false
			$CanvasLayer/Snowballs/ball5.visible = false
		2:
			$CanvasLayer/Snowballs/ball1.visible = true
			$CanvasLayer/Snowballs/ball2.visible = true
			$CanvasLayer/Snowballs/ball3.visible = false
			$CanvasLayer/Snowballs/ball4.visible = false
			$CanvasLayer/Snowballs/ball5.visible = false
		3:
			$CanvasLayer/Snowballs/ball1.visible = true
			$CanvasLayer/Snowballs/ball2.visible = true
			$CanvasLayer/Snowballs/ball3.visible = true
			$CanvasLayer/Snowballs/ball4.visible = false
			$CanvasLayer/Snowballs/ball5.visible = false
		4:
			$CanvasLayer/Snowballs/ball1.visible = true
			$CanvasLayer/Snowballs/ball2.visible = true
			$CanvasLayer/Snowballs/ball3.visible = true
			$CanvasLayer/Snowballs/ball4.visible = true
			$CanvasLayer/Snowballs/ball5.visible = false
		5:
			$CanvasLayer/Snowballs/ball1.visible = true
			$CanvasLayer/Snowballs/ball2.visible = true
			$CanvasLayer/Snowballs/ball3.visible = true
			$CanvasLayer/Snowballs/ball4.visible = true
			$CanvasLayer/Snowballs/ball5.visible = true
		6:
			$CanvasLayer/Snowballs/ball1.visible = false
			$CanvasLayer/Snowballs/ball2.visible = false
			$CanvasLayer/Snowballs/ball3.visible = false
			$CanvasLayer/Snowballs/ball4.visible = false
			$CanvasLayer/Snowballs/ball5.visible = false

func spawn_enemy():
	rng.randomize()
	var x_pos = rng.randi_range(-24, 24)
	while x_pos > -5 and x_pos < 5:
		x_pos = rng.randi_range(-24, 24)
	var z_pos = rng.randi_range(-24, 24)
	
	while z_pos > -5 and z_pos < 5:
		z_pos = rng.randi_range(-24, 24)
	
	var e
	
	match enemyType:
		1:
			e = enemy_1.instance()
		2:
			e = enemy_2.instance()
		3:
			e = enemy_3.instance()
		_:
			e = enemy_1.instance()

	e.type = enemyType
	e.transform.origin = Vector3(x_pos, 2.5, z_pos)
	e.xval = x_pos
	e.zval = z_pos
	e.connect("killed", self, "_on_enemy_killed")
	self.add_child(e)
	enemies_alive += 1
	
	match enemyType:
		1:
			emit_signal("red_spawned")
		2:
			emit_signal("green_spawned")
		3:
			emit_signal("yellow_spawned")
	

func _on_enemy_killed(type):
	player.inc_score()
	enemies_alive -= 1
	set_timer()

func _on_EnemyTimer_timeout():
	spawn_enemy()

func _on_ResetTimer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://MainMenu.tscn")
