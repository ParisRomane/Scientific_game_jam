extends StaticBody2D

var hitpoints = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = (int)(position.y/60)

func on_death():
		drop()
		queue_free()
		
func drop():
	pass

func hit(damage):
	hitpoints -= damage
	
	if(hitpoints >= 15):
		$Sprite2D.frame_coords = Vector2i(0, 2)
		
	elif(hitpoints >= 10):
		$Sprite2D.frame_coords = Vector2i(0, 1)
		
	elif(hitpoints >= 5):
		$Sprite2D.frame_coords = Vector2i(0, 0)
		
	else:
		on_death()
		
