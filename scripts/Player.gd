extends CharacterBody2D


enum {NONE, CU,CO,NI,MG}


var mouse_pos = Vector2()
var vel = Vector2()
var bullet = preload("res://scenes/objects/bullet.tscn")
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
var suicide
@export var is_player = true;
signal send(position, pv, stat_speed, stat_damage, stat_regen, stat_range, name )

var ACC = 50

#player stats
var pv #int between 0 and pv_default
var stat_speed # positive int
var stat_damage # positive int
var stat_regen # positive int
var stat_range # positive int

@export var pv_default = 100 # 100 pv
@export var regen_time_default = 1.0 # time to recover 1 pv in seconds
@export var max_speed = 100
@export var damage_default = 5 # harm to players
@export var range_default = 0.1 # seconds before bullet disappears

signal player_death
signal player_update_pv(pv)
signal add_element(element)

func _ready():
	pv = pv_default
	stat_regen = 0
	stat_speed = 0
	stat_damage = 0
	stat_range = 0
	
	$Arm.animation_finished.connect(_on_shoot_animation_finished)
	
	$Sounds/Hit.stream = load("res://Assets/son/hit.wav")
	$Sounds/Shoot.stream = load("res://Assets/son/shoot.mp3")
	$Sounds/Powerup.stream = load("res://Assets/son/powerup.mp3")
	$Sounds/Loose.stream = load("res://Assets/son/loose.mp3")

func _physics_process(delta):	# 60 FPS (delta is in s)
	if pv <= 0:
		die()
	if is_player :
		action_loop()
		set_velocity(vel)
		move_and_slide()
		vel = velocity
		$Arm.look_at(get_global_mouse_position())
		update_pv(delta) 
		emit_signal("send", position, pv, stat_speed, stat_damage, stat_regen, stat_range, name)
	#update_position()
	

func hit(damage):
	pv -= damage
	$Sounds/Hit.play()
	player_update_pv.emit(pv)
	
	if pv <= 0:
		die()

var regen_clock = 0
func update_pv(delta):
	if stat_regen != 0:
		# real time to recover 1 pv according to the regen stat
		var regen_time = regen_time_default / stat_regen
		
		if regen_clock >= regen_time:
			regen_clock = 0
			if pv < pv_default:
				pv +=1
		
		regen_clock += delta
		
		player_update_pv.emit(pv)

func action_loop():
	right = Input.is_action_pressed("ui_right")
	left = Input.is_action_pressed("ui_left")
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	move = right or left or up or down
	shoot = Input.is_action_pressed("shoot")
	suicide = Input.is_action_just_pressed("ui_cancel")
	
	if !is_dead:
		var coef = 1/(float(pv_default)/float(pv))
		$AnimatedSprite2D.modulate = Color(1, coef, coef)
		$Arm.modulate = Color(1, coef, coef)
	
	movement_loop()
	shooting()

func movement_loop():
	var speed = max_speed * (1 + 0.2 * stat_speed)
	
	#Change z-index priority
	z_index = int(position.y)
	
	if !is_dead:
		if right:
			vel.x = min(vel.x + ACC, speed)
		if left:
			vel.x = max(vel.x - ACC, -speed)
		if up:
			vel.y = max(vel.y - ACC, -speed)
		if down:
			vel.y = min(vel.y + ACC, speed)
		if suicide:
			pv -= 10
	
	#Inertia management
	if !move or is_dead:
		vel.x = lerpf(vel.x, 0, 0.15)
		vel.y = lerpf(vel.y, 0, 0.15)
	
	if abs(vel.x) <= 0.2 and abs(vel.y) <= 0.2:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("move")

func shooting():
	if shoot and can_shoot and !is_dead:
		shoot_line = get_global_mouse_position() - global_position
		var b = bullet.instantiate()
		var rotation = shoot_line.angle()
		can_shoot = false
		
		var damage = damage_default * (1 + 0.2 * stat_damage)
		var range = range_default * (1 + 0.4 * stat_range)
		
		#Bullet spawn
		self.add_collision_exception_with(b)
		b.start($Arm/Marker2D.global_position, rotation, damage, range)
		get_parent().add_child(b)
		
		#Timer start
		if $Reload.is_stopped():
			$Reload.start()
		
		$Arm.play("shoot")
		
		$Sounds/Shoot.play()

func _on_shoot_animation_finished():
	$Arm.play("idle")


func _on_reload_timeout():
	can_shoot = true
	
func upgrade(ind):
	ind = ind+1
	if ind == CU :
		emit_signal("add_element", CU)
	if ind == NI :
		emit_signal("add_element", NI)
	if ind == MG :
		emit_signal("add_element", MG)
	if ind == CO :
		emit_signal("add_element", CO)
	
	$Sounds/Powerup.play()
	
	
func change_setting(list):
	stat_regen = list[0]
	stat_speed = list[1]
	stat_damage = list[2]
	stat_range = list[3]
	
func die():
	player_death.emit()
	$Sounds/Loose.play()
	is_dead = true
	z_index = 0
	$CollisionShape2D.set_disabled(true)
	$Arm.visible = false
	$AnimatedSprite2D.play("idle")
