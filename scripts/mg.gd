extends StaticBody2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.upgrade(2)
		queue_free()