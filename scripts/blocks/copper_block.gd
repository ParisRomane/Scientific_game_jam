extends "res://scripts/blocks/block.gd"

var cu = preload("res://scenes/objects/cu.tscn")

func drop():
	var block = cu.instantiate()
	block.position = Vector2(position.x, position.y + 30)
	get_parent().add_child(block)
