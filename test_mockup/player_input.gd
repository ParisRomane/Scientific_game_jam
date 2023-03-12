extends MultiplayerSynchronizer

signal score_update

# Set via RPC to simulate is_action_just_pressed.
@export var jumping := false
@export var score :=0
# Synchronized property.
@export var direction := Vector2()

func _ready():
	# Only process for the local player
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	#self.connect("score_update",get_node("../../../../../score_max")._change_score)


@rpc("call_local")
func jump():
	jumping = true
	score += 100
	emit_signal('score_update', score,get_multiplayer_authority())
	

func _process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
