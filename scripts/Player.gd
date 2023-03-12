extends CharacterBody2D

enum {NONE, CU,CO,NI,MG}

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $PlayerInput

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

var ACC = 50

#player stats
var pv #int between 0 and pv_default
var stat_speed =0 # positive int
var stat_damage =0 # positive int
var stat_regen =0 # positive int
var stat_mining =0 # positive int

@export var pv_default = 100 # 100 pv
@export var regen_time_default = 1.0 # time to recover 1 pv in seconds
@export var max_speed = 100
@export var damage_default = 1 # harm to players
@export var mining_default = 1 # harm to bocks

signal player_death
#signal player_grab_element(element)
signal player_update_ui(pv)

signal get_element(elem)

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera2D.enabled = true
	else :
		$Camera2D.enabled = false
	
	get_node("../../../../CanvasLayer/"+self.name).connect("update_stat",self.change_setting)
	self.connect("player_update_ui",get_node("../../../../CanvasLayer/"+self.name).change_hp)
	self.connect("get_element",get_node("../../../../CanvasLayer/"+self.name). add_element)
	pv = pv_default
	$Arm.animation_finished.connect(_on_shoot_animation_finished)
	
	$Sounds/Hit.stream = load("res://Assets/son/hit.wav")
	$Sounds/Shoot.stream = load("res://Assets/son/shoot.mp3")

func _physics_process(delta):	# 60 FPS (delta is in s)
	if pv <= 0:
		player_death.emit()
	
	action_loop()
	set_velocity(vel)
	move_and_slide()
	vel = velocity
	
	update_pv(delta)


func hit(damage):
	pv -= damage
	$Sounds/Hit.play()
	player_update_ui.emit(pv)

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
		
		player_update_ui.emit(pv)

func action_loop():
	if player == multiplayer.get_unique_id():
		$Arm.look_at(get_global_mouse_position())
		right = Input.is_action_pressed("ui_right")
		left = Input.is_action_pressed("ui_left")
		up = Input.is_action_pressed("ui_up")
		down = Input.is_action_pressed("ui_down")
		move = right or left or up or down
		shoot = Input.is_action_pressed("shoot")
		
		movement_loop()
		shooting()

func movement_loop():
	var speed = max_speed * (1 + 0.2 * stat_speed)
	
	if !is_dead:
		if right:
			vel.x = min(vel.x + ACC, speed)
		if left:
			vel.x = max(vel.x - ACC, -speed)
		if up:
			vel.y = max(vel.y - ACC, -speed)
		if down:
			vel.y = min(vel.y + ACC, speed)
	
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
		var mining = mining_default * (1 + 0.2 * stat_mining)
		
		#Bullet spawn
		b.start($Arm/Marker2D.global_position, rotation, damage, mining)
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

func change_setting(list):
	stat_regen = list[0]
	stat_speed = list[1]
	stat_damage = list[2]
	stat_mining = list[3]
