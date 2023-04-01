extends Node

var udp := PacketPeerUDP.new()
var connected = false
var player = "player_0"
var data = ""

func connect_ui_to_player(player):
	get_node("Map/"+player).connect.call_deferred("send", send_update)
	get_node("CanvasLayer/1").connect.call_deferred("update_stat",get_node("Map/"+player).change_setting)
	get_node("Map/"+player).connect.call_deferred("player_update_pv",get_node("CanvasLayer/1").change_hp)
	get_node("Map/"+player).connect.call_deferred("add_element",get_node("CanvasLayer/1"). add_element)
	pass

func _ready():
	udp.connect_to_host("127.0.0.1", 4435)


func _process(delta):
	for i in range (udp.get_available_packet_count()) :
		data = udp.get_packet()
		data = data.get_string_from_utf8()
		connected = true
		var info = JSON.parse_string(data.replace("'",'"'))
		if (info != null) :
			update_data(info)
		else : 
			print(data)

	
func send(data: String):
	udp.put_packet(data.to_utf8_buffer())

func update_data(datas):
	if (datas != null):
		for data in datas :
			if ( data['name'] != player ):
				#get_node("Map/"+data['name']).change_setting(data['stat'])
				var position = Vector2(data['position'][0],data['position'][1])
				if (position != get_node("Map/"+data['name']).position ):
					get_node("Map/"+data['name']).position = position
				#get_node("Map/"+data['name']).pv = data['pv']

func send_update(position, pv, stat_speed, stat_damage, stat_regen, stat_range, name  ):
	var data = {"name"= name, "position" = [position.x, position.y], "pv" = pv , "stat" = [ stat_speed, stat_damage, stat_regen, stat_range]}
	send(JSON.stringify(data))
