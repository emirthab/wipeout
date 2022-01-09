extends Spatial

var player = preload("res://assets/sprite/player/Player.tscn").instance()
var PuppetPlayer = preload("res://assets/sprite/player/PuppetPlayer.tscn").instance()
var net = NetworkedMultiplayerENet.new()

func _ready():
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")

func _input(event):

	if Input.is_key_pressed(KEY_H):
		net.create_server(6969,10)
		get_tree().set_network_peer(net)
		print("host başlatılıyor...")
		var id = get_tree().get_network_unique_id()
		player.set_name(str(id))
		player.set_network_master(id)
		add_child(player)
		player.global_transform = $Player1Pos.global_transform

	if Input.is_key_pressed(KEY_J):
		var ip = "192.168.1.119"
		net.create_client(ip,6969)
		get_tree().set_network_peer(net)
		print("Oyuna Katılıyor...")
		var id = get_tree().get_network_unique_id()
		player.set_name(str(id))
		player.set_network_master(id)
		add_child(player)
		player.global_transform = $Player2Pos.global_transform


func _player_connected(id):
	PuppetPlayer.set_name(str(id))
	PuppetPlayer.set_network_master(id)
	print("oyuncu baglandi ", id)
	add_child(PuppetPlayer)
	if id == 1:
		PuppetPlayer.global_transform = $Player1Pos.global_transform
	else:
		PuppetPlayer.global_transform = $Player2Pos.global_transform

func _player_disconnected(id):
	get_node(str(get_tree().current_scene,"/",id)).queue_free()
