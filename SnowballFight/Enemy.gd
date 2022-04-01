extends KinematicBody

signal killed(type)

var type: int = 1

var can_shoot: bool = true
var hidden: bool = false
var xval: = 0
var zval: = 0

onready var snowball = preload("res://SnowballFight/Snowball.tscn")

var rng = RandomNumberGenerator.new()

func _process(delta):
	if $VisibilityNotifier.is_on_screen() and can_shoot:
		$ShootTimer.start()
		can_shoot = false
	if not hidden:
		match type:
			1:
				$Enemy1.visible = true
				$Enemy2.visible = false
				$Enemy3.visible = false
			2:
				$Enemy1.visible = false
				$Enemy2.visible = true
				$Enemy3.visible = false
			3:
				$Enemy1.visible = false
				$Enemy2.visible = false
				$Enemy3.visible = true

func _ready():
	$ShootTimer.wait_time = rng.randf_range(2.0, 3.5)

func kill():
	emit_signal("killed", type)
	$QueueTimer.start()
	print("hidden")
	$Enemy1.visible = false
	$Enemy2.visible = false
	$Enemy3.visible = false
	$CollisionShape.disabled = true
	hidden = true

func shoot():
	var aim_height = ((abs(xval) + abs(zval)) / 2) / 1.8
	var s = snowball.instance()
	$Eyes.add_child(s)
	s.remove_from_group("Enemy")
	s.look_at(Vector3(0, aim_height, 0), Vector3.UP)
	s.shoot = true
	$ShootTimer.start()
	can_shoot = true
	
func _on_ShootTimer_timeout():
	if not hidden:
		rng.randomize()
		$ShootTimer.wait_time = rng.randf_range(1.5, 3.0)
		shoot()


func _on_QueueTimer_timeout():
	queue_free()
