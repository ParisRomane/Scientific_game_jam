extends Node

var peer = ENetMultiplayerPeer.new()
const PORT = 4437


func _ready():
	# Start paused
	get_tree().paused = false
	


func _on_host_pressed():
	print("here")
	# Start as server
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server")
		##PROVISOIRE : 
		_on_connect_pressed()
		return
	multiplayer.multiplayer_peer = peer
	start_game()
	


func _on_connect_pressed():
	print("there")
	# Start as client
	var id = peer.create_client("127.0.0.1", PORT)
	print(peer)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game():
	# Hide the UI and unpause to start the game.
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://scenes/level.tscn"))
	else :
		$Level/Level.start()
		


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	var instance = scene.instantiate()
	instance.position = get_viewport().size/2
	level.add_child(instance)
	$Level/Level.start()


