extends StaticBody2D

var hitpoints = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hit(damage):
	hitpoints -= damage
	print(damage)
	
	if(hitpoints >= 15):
		$Sprite2D.frame_coords = Vector2i(0, 2)
		
	elif(hitpoints >= 10):
		$Sprite2D.frame_coords = Vector2i(0, 1)
		
	elif(hitpoints >= 5):
		$Sprite2D.frame_coords = Vector2i(0, 0)
		
	else:
		queue_free()
		
