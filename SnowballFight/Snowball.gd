extends RigidBody

# Bullet code taken from: https://kidscancode.org/godot_recipes/g101/3d/101_3d_04/

export var speed: int = 10
var shoot: bool = false

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * speed)
		shoot = false

func _on_Area_body_entered(body):
	if body.is_in_group("Enemy"):
		body.kill()
		queue_free()
	elif body.is_in_group("Player"):
		queue_free()
	else:
		queue_free()


func _on_CollTimer_timeout():
	$CollisionShape.disabled = false
	$Area/CollisionShape.disabled = false
