extends CharacterBody2D

const SPEED = 1000
var vel = Vector2()
var damage # harm in pv to player
var ttl # time to live

var time_counter

func start(pos, dir, dam, ran):
	$AnimatedSprite2D.rotate(dir)
	position = pos
	damage = dam
	ttl = ran
	vel = Vector2(SPEED, 0).rotated(dir)
	time_counter = 0

func _physics_process(delta):
	time_counter += delta
	if time_counter >= ttl:
		queue_free()
	
	var collision = move_and_collide(vel*delta)
	var tilemap = get_parent().get_node("TileMap")
	
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage);
			
		if collision.get_collider().name == "TileMap":
			tilemap.on_hit(collision, 10)
			get_parent().get_node("Break").play()
		
		queue_free()
