@tool extends Node2D

@export var type : String
@export var cellPos = Vector2(0, 0)
@export var texture = Texture : set = setTexture, get = getTexture

@export var passable = true

func setTexture(newTexture):
	texture = newTexture
	update()

func update():
	if has_node("Texture"):
		$Texture.texture = texture

func _init():
	var sprite = Sprite2D.new()
	sprite.name = "Texture"
	add_child(sprite)

func _ready():
	update()

func getTexture():
	return texture
