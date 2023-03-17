extends "res://scripts/blocks/block.gd"

var mg = preload("res://scenes/objects/mg.tscn")

func drop():
	print("done")
	var block = mg.instantiate()
	block.position = Vector2(position.x, position.y + 30)
	get_parent().add_child(block)
