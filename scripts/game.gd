extends Node

var peer = ENetMultiplayerPeer.new()
const PORT = 4433


func _ready():
	get_node("CanvasLayer/1").connect.call_deferred("update_stat",get_node("Level/Player").change_setting)
	get_node("Level/Player").connect.call_deferred("player_update_pv",get_node("CanvasLayer/1").change_hp)
	get_node("Level/Player").connect.call_deferred("add_element",get_node("CanvasLayer/1"). add_element)
	pass
