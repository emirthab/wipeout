extends Node

export var websocket_url = "ws://192.168.1.109:5000"

var _client = WebSocketClient.new()

func Connect():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	set_process(false)
	GlobalVariables.id = ""

func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	sendPacket([1,str('"' + GlobalVariables.username+'"')])

func _on_data():
	var response = _client.get_peer(1).get_packet().get_string_from_utf8()
	response = response.replace("'",'"')
	var resp := str2var(response) as Array
	match resp[0]:
		2 :
			GlobalVariables.id = resp[1]
		3 :
			var puppetPlayer = load("res://assets/sprite/player/PuppetPlayer.tscn").instance()
			puppetPlayer.name = str(resp[1])
			puppetPlayer.get_node("Networking").setName(str(resp[2]))
			get_tree().current_scene.get_node("MAP/otherPlayers").add_child(puppetPlayer)
		4 :
			for player in resp[1]:
				var puppetPlayer = load("res://assets/sprite/player/PuppetPlayer.tscn").instance()
				puppetPlayer.name = str(player["id"])
				puppetPlayer.get_node("Networking").setName(str(player["name"]))
				get_tree().current_scene.get_node("MAP/otherPlayers").add_child(puppetPlayer)
		7:
			get_tree().current_scene.get_node(str("MAP/otherPlayers/", str(resp[1]) )).queue_free()
		6:
			var _pos = resp[2].split(",")
			var pos = Vector3(float(_pos[0]),float(_pos[1]),float(_pos[2]))
			var playerNodePath = str("MAP/otherPlayers/", str(resp[1]))
			if get_tree().current_scene.has_node(playerNodePath):
				get_tree().current_scene.get_node(playerNodePath).global_transform.origin = pos
		9:
			get_tree().current_scene.get_node("MAP/Player/Networking").setPing()
		11:
			var _rot = resp[2].split(",")
			var rot = Vector3(float(_rot[0]),float(_rot[1]),float(_rot[2])) 
			var modelNodePath = str("MAP/otherPlayers/", str(resp[1]),"/Model" )
			if get_tree().current_scene.has_node(modelNodePath):
				get_tree().current_scene.get_node(modelNodePath).rotation = rot
		13:
			print(resp)
			var messageLine = str("[b]",resp[1]," : [/b]",str(resp[2]))
			var chatText = get_tree().current_scene.get_node("MAP/Player/gui/chat/ChatText")
			if chatText.bbcode_text != "":
				messageLine = str("\n",messageLine)
			chatText.bbcode_text += messageLine

func _process(delta):
	_client.poll()

func sendPacket(packet):
	_client.get_peer(1).put_packet(str(packet).to_utf8())
