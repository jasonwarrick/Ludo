extends KinematicBody2D

var velocity = Vector2(0, 0) #create the vector by which the character moves
var SPEED = 500
var JUMPFORCE = -775
var GRAVITY = 30
var hurt: = false

func _ready():
	randomize()

func _physics_process(delta): #this runs every (physics frame)
	$AnimatedSprite.animation = "Running"
	
	if Input.is_action_pressed("slide") and not is_on_floor():
		GRAVITY = 60
	else:
		GRAVITY = 30
	
	velocity.y += GRAVITY #gravity value (0 is the top, max positivr value is the bottom of the screen)
	
	if Input.is_action_just_pressed("jump") and is_on_floor(): #just_pressed means that it can't be held
		velocity.y = JUMPFORCE
		jump_sound()
	
	if velocity.y < 0 and not is_on_floor():
		$AnimatedSprite.animation = "Jumping1"
	elif velocity.y > 0 and not is_on_floor():
		$AnimatedSprite.animation = "Jumping2"
	
	if Input.is_action_pressed("slide"):
		self.rotation_degrees = -65
		$AnimatedSprite.animation = "Sliding"
	else:
		self.rotation_degrees = 0
	
	if hurt:
		$AnimatedSprite.animation = "Hurt"
	
	velocity = move_and_slide(velocity, Vector2.UP) #resetting velocity to the value of move_and_slide(velocity) allows it to factor in collisions
	#the Vector2.Up parameter defines which direction is up, thus which is the floor. The "UP" is just a Vector2 shortcut for (0, -1)
	self.transform.origin.x = 210

func jump_sound():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	match rng.randi_range(1,3):
		1:
			$SFX/Jump1.playing = true
		2:
			$SFX/Jump2.playing = true
		3:
			$SFX/Jump3.playing = true

func hurt_sound():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	match rng.randi_range(1,3):
		1:
			$SFX/Hurt1.playing = true
		2:
			$SFX/Hurt2.playing = true
		3:
			$SFX/Hurt3.playing = true

func hurt():
	hurt = true
	hurt_sound()
	$AnimatedSprite.animation = "Hurt"
	self.set_collision_layer_bit(0, false)
	$HurtTimer.start()

func _on_HurtTimer_timeout():
	hurt = false
	self.set_collision_layer_bit(0, true)
	$AnimatedSprite.animation = "Running"
