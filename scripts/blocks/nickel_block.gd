extends "res://scripts/blocks/block.gd"

var ni = preload("res://scenes/objects/ni.tscn")

func drop():
	var block = ni.instantiate()
	block.position = Vector2(position.x, position.y + 30)
	get_parent().add_child(block)
