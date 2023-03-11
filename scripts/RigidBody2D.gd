extends RigidBody2D

var bullet_scene = preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	shoot()

func shoot():
	if Input.is_action_pressed("ui_select"):
		print("pan")
		var bullet = bullet_scene.instantiate()
		var shootline := get_global_mouse_position() - global_position
		bullet.start($Arm/Marker2D.position, shootline.angle())
		get_parent().add_child(bullet)

var THRUST = 5000
var FRICTION = 10

func move():
	var force = Vector2.ZERO
	
	if Input.is_action_pressed('ui_up'):
		force.y = - THRUST
	if Input.is_action_pressed('ui_down'):
		force.y = THRUST
	if Input.is_action_pressed('ui_left'):
		force.x = - THRUST
	if Input.is_action_pressed('ui_right'):
		force.x = THRUST
	
	force -= FRICTION * linear_velocity
	
	apply_force(force)
