extends CharacterBody2D


enum {NONE, CU,CO,NI,MG}

var is_player = true
#Animation state machines
var _state_machine
var _body_anim_tree
var _arm_anim_tree
var _death_anim_tree

var bullet = preload("res://scenes/objects/bullet.tscn")
var is_dead = false
var is_dying = false #Used once when the player die
var can_shoot = true
var shoot_line

#movement et acceleration
var movement = Vector2(0,0)
var ACC = 50
# pv related variables
var shoot = false
var suicide = false
var regen_clock = 0

#position de la souris : utile a stocker pour ceux qui ne sont pas le player principal
var mouse_pos = get_global_mouse_position()
#player stats
var pv #int between 0 and pv_default
var stat_speed = 0 # positive int
var stat_damage = 0 # positive int
var stat_regen = 0 # positive int
var stat_frequence = 0 # positive int

@export var pv_default = 100 # 100 pv
@export var regen_time_default = 1.0 # time to recover 1 pv in seconds
@export var max_speed = 100
@export var damage_default = 5 # harm to players or blocks
@export var frequence_default = 1 # shoot per second

signal player_death
signal player_update_pv(pv)
signal add_element(element)
signal send(name, position, movement, pv, list_stat, arm )
signal sig_shoot(msg)

func _ready():
	
	_body_anim_tree = $BodyAnimationTree.get("parameters/playback")
	_state_machine = $BodyAnimationTree
	_arm_anim_tree = $ArmAnimationTree.get("parameters/playback")
	
	pv = pv_default
	
	$Sounds/Hit.stream = load("res://assets/son/hit.wav")
	$Sounds/Shoot.stream = load("res://assets/son/shoot.mp3")
	$Sounds/Powerup.stream = load("res://assets/son/powerup.mp3")
	$Sounds/Loose.stream = load("res://assets/son/loose.mp3")

func _physics_process(delta):	# 60 FPS (delta is in s)
	if is_player :
		mouse_pos = get_global_mouse_position()
		action_loop()
		update_pv(delta) 
		emit_signal("send", name, position, movement, pv, [stat_speed, stat_damage, stat_regen, stat_frequence ],mouse_pos)
	$Arm.look_at(mouse_pos)
	movement_loop()
	move_and_slide()
	shooting()
	animation_loop()

func hit(damage):
	pv -= damage
	$Sounds/Hit.play()
	player_update_pv.emit(pv)
	
	if pv <= 0:
		die()

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
	movement.x =  int(Input.is_action_pressed("ui_right")) *1 + int(Input.is_action_pressed("ui_left")) * (-1)
	movement.y = int(Input.is_action_pressed("ui_down")) *1 + int(Input.is_action_pressed("ui_up"))*(-1)

	shoot = Input.is_action_pressed("shoot")
	suicide = Input.is_action_just_pressed("ui_cancel")
	

func movement_loop():
	var speed = max_speed * (1.2 + 0.1 * stat_speed)
	
	#Change z-index priority
	z_index = int(position.y/60)
	
	if !is_dead:
		velocity.x = max( min(velocity.x + movement.x * ACC, speed), -speed)
		velocity.y = max( min(velocity.y + movement.y * ACC, speed), -speed)
		if suicide:
			hit(10)
	
	#Inertia management
	if (movement == Vector2(0,0)) or is_dead:
		velocity.x = lerpf(velocity.x, 0, 0.15)
		velocity.y = lerpf(velocity.y, 0, 0.15)
		
func modulate():
	var coef = 1/(float(pv_default)/float(pv))
	$Character.modulate = Color(1, coef, coef)
	$Arm.modulate = Color(1, coef, coef)
		
func animation_loop():
	if !is_dead:
		modulate()
		
		if (movement == Vector2(0,0)):
			_body_anim_tree.travel("Idle")
		else:
			_state_machine.set('parameters/Run/blend_position', movement.normalized())
			_body_anim_tree.travel("Run")

		if shoot:
			_arm_anim_tree.travel("Shoot")

	if is_dying:
		is_dying = false
		$Character.hide()
		$Arm.hide()
		$Death.show()
		_body_anim_tree.travel("Dying")
		

func shooting():
	if shoot and can_shoot and !is_dead:
		_arm_anim_tree.travel("Shoot")
		shoot_line = mouse_pos - global_position
		var b = bullet.instantiate()
		var rotation = shoot_line.angle()
		can_shoot = false
		shoot = false
		var damage = damage_default * (0.5 + 0.05 * stat_damage)
		
		#Bullet spawn
		self.add_collision_exception_with(b)
		b.start($Arm/Marker2D.global_position, rotation, damage)
		get_parent().add_child(b)
		var frequence = frequence_default * (1 + 0.05 * stat_frequence)
		$Reload.wait_time = 1/frequence
		#Timer start
		if $Reload.is_stopped():
			$Reload.start()
		
		$Sounds/Shoot.play()
		emit_signal("sig_shoot", "SHOOT "+name+" ")

func _on_reload_timeout():
	can_shoot = true
	
func upgrade(ind):
	ind = ind+1
	match ind :
		CU :
			emit_signal("add_element", CU)
		NI :
			emit_signal("add_element", NI)
		MG :
			emit_signal("add_element", MG)
		CO :
			emit_signal("add_element", CO)
	
	$Sounds/Powerup.play()
	
	
func change_setting(list):
	stat_regen = list[0]
	stat_speed = list[1]
	stat_damage = list[2]
	stat_frequence = list[3]
	
func die():
	#envoie le signal de mort
	player_death.emit()
	$Sounds/Loose.play()
	is_dead = true
	is_dying = true
	z_index = 0
	$CollisionShape2D.set_disabled(true)
