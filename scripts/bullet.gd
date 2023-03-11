extends CharacterBody2D

const SPEED = 1000
var vel = Vector2()
var damage = 50

func start(pos, dir):
	$Sprite2D.rotate(dir)
	position = pos
	vel = Vector2(SPEED, 0).rotated(dir)

func _physics_process(delta):
	var collision = move_and_collide(vel*delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage);
		
		if collision.get_collider().has_method("window"):
			collision.get_collider().window(rad_to_deg(vel.angle()));
		queue_free()
