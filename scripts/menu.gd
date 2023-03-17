extends Node2D

enum { MENU, AUTHORS, CREDITS }
var scene = MENU

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func change_scene(screen):
	$authors.hide()
	$menu.hide()
	$credits.hide()
	$authors/authors_close.disabled = true
	$credits/credits_close.disabled = true
	$menu/exit.disabled = true
	match screen :
		MENU : 
			$menu.show()
			$menu/exit.disabled = false
		AUTHORS : 
			$authors.show()
			$authors/authors_close.disabled = false
		CREDITS : 
			$credits.show()
			$credits/credits_close.disabled = false
	
func load_game():
	pass
	

func _on_authors_close_pressed():
	change_scene(MENU)

func _on_authors_open_pressed():
	change_scene(AUTHORS)

func _on_credits_close_pressed():
	change_scene(MENU)

func _on_credits_open_pressed():
	change_scene(CREDITS)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/concrete_scenes/game.tscn")


func _on_exit_pressed():
	get_tree().quit()
