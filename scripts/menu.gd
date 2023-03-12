extends Node2D

enum { MENU, CREDIT,EXPLAIN }
var scene = MENU

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func change_scene(screen):
	$credit.hide()
	$menu.hide()
	$explain.hide()
	$credit/credit_close.disabled = true
	$explain/explain_close.disabled = true
	$menu/exit.disabled = true
	match screen :
		MENU : 
			$menu.show()
			$menu/exit.disabled = false
		CREDIT : 
			$credit.show()
			$credit/credit_close.disabled = false
		EXPLAIN : 
			$explain.show()
			$explain/explain_close.disabled = false
	
func load_game():
	pass
	

func _on_credit_close_pressed():
	change_scene(MENU)

func _on_credit_open_pressed():
	change_scene(CREDIT)

func _on_explain_open_pressed():
	change_scene(EXPLAIN)


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed():
	get_tree().quit()
