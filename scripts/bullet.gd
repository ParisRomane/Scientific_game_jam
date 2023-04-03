extends CharacterBody2D

const SPEED = 1000
var vel = Vector2()
var damage # harm in pv to player
@export var ttl = 2 # time to live in s

var time_counter

func start(pos, dir, dam):
	$AnimatedSprite2D.rotate(dir)
	position = pos
	damage = dam
	vel = Vector2(SPEED, 0).rotated(dir)
	time_counter = 0
	
	#Change z-index priority
	z_index = (int)(position.y/60)

func _physics_process(delta):
	time_counter += delta
	if time_counter >= ttl:
		print("autodestruction")
		queue_free()
	
	var collision = move_and_collide(vel*delta)
	
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage);
			#get_parent().get_node("Break").play()
		
		queue_free()
