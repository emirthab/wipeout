extends Node

var _client = WebSocketClient.new()

signal playerNetworking(resp)
signal chat(resp)

func Connect():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(GlobalVariables.websocketServer)
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
		9 , 6 , 11: emit_signal("playerNetworking",resp)
		13 : emit_signal("chat",resp)
		2  : GlobalVariables.id = resp[1]
		3  : 
			addPlayerInGame(resp[1],resp[2])
			var playerNet = get_tree().current_scene.get_node("MAP/Player/Networking")
			playerNet.sendPos() ; playerNet.sendRot()
			
		4  : for player in resp[1]: addPlayerInGame(player["id"],player["name"])
		7  : removePlayerInGame(resp[1])


func _process(delta):
	_client.poll()

func sendPacket(packet):
	_client.get_peer(1).put_packet(str(packet).to_utf8())

func addPlayerInGame(id,name):
	var puppetPlayer = load("res://assets/sprite/player/PuppetPlayer.tscn").instance()
	puppetPlayer.name = str(id)
	puppetPlayer.get_node("Networking").setName(str(name))
	get_tree().current_scene.get_node("MAP/otherPlayers").add_child(puppetPlayer)
	GlobalVariables.connectedPlayers.append(str(id))

func removePlayerInGame(id):
	get_tree().current_scene.get_node(str("MAP/otherPlayers/", str(id) )).queue_free()
