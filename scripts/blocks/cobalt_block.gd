extends "res://scripts/blocks/block.gd"

var co = preload("res://scenes/objects/co.tscn")

func drop():
	print("done")
	var block = co.instantiate()
	block.position = Vector2(position.x, position.y + 30)
	get_parent().add_child(block)
