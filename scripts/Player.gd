extends CharacterBody2D

var mouse_pos = Vector2()
var vel = Vector2()
var bullet = preload("res://scenes/bullet.tscn")
var is_dead = false
var can_shoot = true
var shoot_line

#Key var
var right
var left
var up
var down
var move
var shoot

@export var max_speed = 300

var ACC = 50

func _ready():
	pass

func _physics_process(delta):	# 60 FPS
	action_loop()
	set_velocity(vel)
	move_and_slide()
	vel = velocity

func action_loop():
	
	right = Input.is_action_pressed("ui_right")
	left = Input.is_action_pressed("ui_left")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	move = right or left or up or down
	shoot = Input.is_action_pressed("shoot")
	
	movement_loop()
	shooting()

func movement_loop():
	
	if !is_dead:
		if right:
			vel.x = min(vel.x + ACC, max_speed)
		if left:
			vel.x = max(vel.x - ACC, -max_speed)
		if up:
			vel.y = max(vel.y - ACC, -max_speed)
		if down:
			vel.y = min(vel.y + ACC, max_speed)
	
	#Inertia management
	if !move or is_dead:
		vel.x = lerpf(vel.x, 0, 0.15)
		vel.y = lerpf(vel.y, 0, 0.15)

func shooting():
	
	if shoot and can_shoot and !is_dead:
		shoot_line = get_global_mouse_position() - global_position
		var b = bullet.instantiate()
		var rotation = shoot_line.angle()
		can_shoot = false
		
		#Bullet spawn
		b.start($Arm/Marker2D.global_position, rotation)
		get_parent().add_child(b)
		
		#Timer start
		if $Reload.is_stopped():
			$Reload.start()


func _on_reload_timeout():
	can_shoot = true
