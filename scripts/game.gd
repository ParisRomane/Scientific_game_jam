extends Node

signal connected      # Connected to server
signal disconnected   # Disconnected from server
signal error          # Error with connection to server
var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()
var player = "Player_0"


func connect_ui_to_player(player):
	print("Level/"+player)
	get_node("Level/"+player).connect.call_deferred("send", send_update)
	get_node("CanvasLayer/1").connect.call_deferred("update_stat",get_node("Level/"+player).change_setting)
	get_node("Level/"+player).connect.call_deferred("player_update_pv",get_node("CanvasLayer/1").change_hp)
	get_node("Level/"+player).connect.call_deferred("add_element",get_node("CanvasLayer/1"). add_element)
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	_status = _stream.get_status()
	print(_status)
	connect_to_server("127.0.0.1",4435)
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
			var data: Array = _stream.get_partial_data(available_bytes)
			# Check for read error.
			if data[0] != OK:
				print("Error getting data from stream: ", data[0])
				emit_signal("error")
			else:
				var info = data[1].get_string_from_utf8()
				update_data(JSON.parse_string(info.replace("'",'"')))
	
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

func update_data(datas):
	if (datas != null):
		for data in datas :
			if ( data['name'] != player ):
				get_node("Level/"+data['name']).change_setting(data['stat'])
				get_node("Level/"+data['name']).position = Vector2(data['position'][0],data['position'][1])
				get_node("Level/"+data['name']).pv = data['pv']

func send_update(position, pv, stat_speed, stat_damage, stat_regen, stat_range, name  ):
	var data = {"name"= name, "position" = [position.x, position.y], "pv" = pv , "stat" = [ stat_speed, stat_damage, stat_regen, stat_range]}
	send(JSON.stringify(data))
