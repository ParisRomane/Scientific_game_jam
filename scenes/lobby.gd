extends Node2D

signal connected      # Connected to server
signal disconnected   # Disconnected from server
signal error          # Error with connection to server
var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	_status = _stream.get_status()
	print(_status)
	connect_to_server("127.0.0.1",4433)
	pass # Replace with function body.



func _process(delta: float) -> void:
	_stream.poll()
	var new_status: int = _stream.get_status()
	if new_status != _status:
		_status = new_status
		match _status:
			_stream.STATUS_NONE:
				print("Disconnected from host.")
				emit_signal("disconnected")
			_stream.STATUS_CONNECTING:
				print("Connecting to host.")
			_stream.STATUS_CONNECTED:
				print("Connected to host.")
				emit_signal("connected")
			_stream.STATUS_ERROR:
				print("Error with socket stream.")
				emit_signal("error")
	#recive data
	if _status == _stream.STATUS_CONNECTED:
		var available_bytes: int = _stream.get_available_bytes()
		if available_bytes > 0:
			print("available bytes: ", available_bytes)
			var data: Array = _stream.get_partial_data(available_bytes)
			# Check for read error.
			if data[0] != OK:
				print("Error getting data from stream: ", data[0])
				emit_signal("error")
			else:
				print((data[1].get_string_from_utf8().replace("'",'"')))
				update_data(JSON.parse_string(data[1].get_string_from_utf8().replace("'",'"')))
	
	#send data
	


func connect_to_server(host: String, port: int) -> void:
	print("Connecting to %s:%d" % [host, port])
	# Reset status so we can tell if it changes to error again.
	_status = _stream.STATUS_NONE
	if _stream.connect_to_host(host, port) != OK:
		print("Error connecting to host.")
		emit_signal("error")
	
func send(sdata: String) -> bool:
	var data = sdata.to_utf8_buffer()
	if _status != _stream.STATUS_CONNECTED:
		print("Error: Stream is not currently connected.")
		return false
	var error: int = _stream.put_data(data)
	if error != OK:
		print("Error writing to stream: ", error)
		return false
	return true

var connect_scene = preload("res://scenes/connect.tscn")
func update_data(data):
	print(data)
	for n in $lobby_L/VBoxContainer.get_children():
		$lobby_L/VBoxContainer.remove_child(n)
		n.queue_free()
	for i in range(len(data)):
		var co = connect_scene.instantiate()
		co.setup(data[i],i)
		co.connect("co", self._on_connect_pressed)
		$lobby_L/VBoxContainer.add_child(co)
	

func _on_connect_pressed(msg):
	if (($lobby_R/pseudo.text).replace(" ","") == "") :
		print("erreur avec le pseudo")
		return -1
	send(msg + " "+ $lobby_R/pseudo.text )

func _on_host_pressed():
	var string = "LOBBY HOST "+ $lobby_R/pseudo.text
	send(string)
	pass # Replace with function body.
	
