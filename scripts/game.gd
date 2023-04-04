extends Node

var udp := PacketPeerUDP.new()
var connected = false
var player = "Player_0"
var data = ""
var port = 42

func connect_ui_to_player(player):
	get_node("Level/"+player).connect.call_deferred("send", send_update)
	get_node("CanvasLayer/1").connect.call_deferred("update_stat",get_node("Level/"+player).change_setting)
	get_node("Level/"+player).connect.call_deferred("player_update_pv",get_node("CanvasLayer/1").change_hp)
	get_node("Level/"+player).connect.call_deferred("add_element",get_node("CanvasLayer/1"). add_element)
	get_node("Level/"+player).connect.call_deferred("sig_shoot", send)
	pass

func _ready():
	get_tree().set_auto_accept_quit(false)
	udp.connect_to_host("127.0.0.1", port)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		#player dies
		get_tree().quit() 
		pass

func _process(delta):
	for i in range (udp.get_available_packet_count()) :
		data = udp.get_packet()
		data = data.get_string_from_utf8()
		connected = true
		if (data.split(" ")[0] == "SHOOT") :
			print(data, data.split(" "),data.split(" ")[0] == "SHOOT")
			if !get_node("Level/"+data.split(" ")[1]).is_player :
				print( "here : ", str(get_node("Level/"+data.split(" ")[1]).shoot) )
				get_node("Level/"+data.split(" ")[1]).shoot = true
				get_node("Level/"+data.split(" ")[1]).can_shoot = true
		else :
			var info = JSON.parse_string(data.replace("'",'"'))
			if (info != null) :
				update_data(info)

	
func send(data: String):
	udp.put_packet(data.to_utf8_buffer())

func update_data(datas):
	if (datas != null):
		for data in datas :
			if ( data['name'] != player ):
				get_node("Level/"+data['name']).position = Vector2(data['position'][0],data['position'][1])
				get_node("Level/"+data['name']).movement = Vector2(data['movement'][0],data['movement'][1])
				get_node("Level/"+data['name']).pv = data['pv']
				get_node("Level/"+data['name']).change_setting(data['stat'])
				get_node("Level/"+data['name']).mouse_pos = Vector2 (data['arm'][0],data['arm'][1])

func send_update(name, position, movement, pv, list_stat, arm ):
	var data = {"name"= name, "position" = [position.x, position.y],"movement" = [movement.x, movement.y], "pv" = pv , "stat" = list_stat, "arm" = [arm.x, arm.y] }
	send(JSON.stringify(data))
