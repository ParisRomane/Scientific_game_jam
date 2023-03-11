extends CharacterBody2D

const SPEED = 1000
var vel = Vector2()
var damage

func start(pos, dir, dam):
	$Sprite2D.rotate(dir)
	position = pos
	damage = dam
	vel = Vector2(SPEED, 0).rotated(dir)
	print("shoot")

func _physics_process(delta):
	var collision = move_and_collide(vel*delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage);
		
		if collision.get_collider().has_method("window"):
			collision.get_collider().window(rad_to_deg(vel.angle()));
		queue_free()
		print("DESTROY !")
