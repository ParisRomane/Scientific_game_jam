extends RigidBody2D

var bullet_scene = preload("res://scenes/bullet.tscn")


# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)
		print(id)

# Player synchronized input.
@onready var input = $PlayerInput

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera2D.enabled = true
	else :
		$Camera2D.enabled = false
	# Only process on server.
	# EDIT: Left the client simulate player movement too to compesate network latency.
	# set_physics_process(multiplayer.is_server())

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
