extends KinematicBody2D

signal game_over

var wheel_base: float = 70 #Car driving code taken from: https://www.youtube.com/watch?v=mJ1ZfGDTMCY
var steering_angle: float = 25
var engine_power: float = 800
var boosted_engine: float = 1400
var friction: float = -0.9
var drag: float = -0.0015
var braking: float =-450
var slip_speed = 500  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction
var max_speed_reverse: int = 250
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle
var collided: bool = false
var game_flag: bool = false

var health: float = 100.0
var damage_quotient: float = 20.0

var gas: float = 100.0
var gas_speed: float = 0.074
var boost_add: float = 0.001
var max_boost_cost: float = 0.1
var reverse_quotient: float = 1.5

export var score: int = 0

func _ready():
	$SFX/Drive.playing = true

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	if (gas <= 0 or health <= 0) and not game_flag:
		print("timer started")
		$gameTimer.start()
		game_flag = true

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force

func damage_health():
	$SFX/Hit.playing = true
	var damage = velocity.length() / damage_quotient
	health -= damage

func get_input():
	var turn = 0
	if Input.is_action_pressed("move_right"):
		turn += 1
	elif Input.is_action_pressed("move_left"):
		turn -= 1
	steer_angle = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("move_forward") and gas > 0 and health > 0 and not collided:
		var drive_vol = $SFX/Drive.volume_db
		if $SFX/Drive.volume_db >= 0:
			$SFX/Drive.volume_db = 0
		else:
			$SFX/Drive.volume_db += 5
		
		if not collided:
			if Input.is_action_pressed("boost"):
				gas -= gas_speed + boost_add
				acceleration = transform.x * boosted_engine
				boost_add += 0.0015
				if boost_add > max_boost_cost:
					boost_add = max_boost_cost
			else:
				boost_add = 0
				gas -= gas_speed
				acceleration = transform.x * engine_power
		
	else:
		if $SFX/Drive.volume_db >= -80:
			$SFX/Drive.volume_db = -80
		else:
			$SFX/Drive.volume_db -= 10
	if Input.is_action_pressed("move_backward") and gas > 0 and health > 0:
		gas -= gas_speed / reverse_quotient
		acceleration = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func refill():
	print("refilled")
	$SFX/Fuel.playing = true
	gas = 100.0

func _on_CollisionArea_body_entered(body):
	damage_health()

func _on_gameTimer_timeout():
	print("timer ended")
	if gas <= 0 or health <= 0:
		print("game over")
		emit_signal("game_over")
	else:
		game_flag = false

func inc_score():
	score += 1

func _on_CollisionArea_body_exited(body):
	collided = false
