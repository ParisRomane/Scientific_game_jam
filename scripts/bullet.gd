extends CharacterBody2D

const SPEED = 1000
var vel = Vector2()
var damage # harm in pv to player
var mining # harm to block

func start(pos, dir, dam, min):
	$Sprite2D.rotate(dir)
	position = pos
	damage = dam
	mining = min
	vel = Vector2(SPEED, 0).rotated(dir)

func _physics_process(delta):
	var collision = move_and_collide(vel*delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage);
		
		if collision.get_collider().has_method("window"):
			collision.get_collider().window(rad_to_deg(vel.angle()));
		queue_free()
		print("DESTROY !")
