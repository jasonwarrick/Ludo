extends StaticBody

var cam_speed = 0.002

var snowballs: int = 5
var reload: int = 0

var score: int = 0
var score_inc: int = 15

var health: int = 3

onready var snowball = preload("res://SnowballFight/Snowball.tscn")

var ducking: bool = false

onready var camera = $Pivot/Camera
onready var aimcast = $Pivot/Camera/AimCast # all shooting code taken from Garbaj "Godot FPS Tutorial - Projectile Weapons" - youtube.com/watch?v=IDsoEAj5xG0
onready var shootcast= $Pivot/Camera/ShootCast

func inc_score():
	score += score_inc

func _ready():
	$ShotCooldown.start()
	
	self.transform.origin = Vector3(0, 0.75, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_just_pressed("duck") and not ducking:
		ducking = true
		$CollisionShape.disabled = true
		$Area/CollisionShape.disabled = true
		$AnimationPlayer.play("Duck")
	elif Input.is_action_just_pressed("stand") and ducking:
		ducking = false
		$CollisionShape.disabled = false
		$Area/CollisionShape.disabled = false
		$AnimationPlayer.play_backwards("Duck")
		reload = 0
	if Input.is_action_pressed("reload") and ducking:
		reload += 1
		if reload >= 30 and snowballs <= 4:
			snowballs += 1
			reload = 0
	if Input.is_action_just_pressed("shoot") and not ducking and snowballs > 0 and snowballs <= 5:
		if aimcast.is_colliding() and $ShotCooldown.time_left == 0:
			snowballs -= 1
			var s = snowball.instance()
			$Pivot.add_child(s)
			s.look_at(shootcast.get_collision_point(), Vector3.UP)
			s.shoot = true
			$ShotCooldown.start()

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * cam_speed)
		$Pivot.rotate_x(-event.relative.y * cam_speed)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)


func _on_Level_green_spawned():
	$AnimationPlayer.play("SpawnGreen")

func _on_Level_red_spawned():
	$AnimationPlayer.play("SpawnRed")

func _on_Level_yellow_spawned():
	$AnimationPlayer.play("SpawnYellow")

func _on_Area_body_entered(body):
	health -= 1
	print(health)
