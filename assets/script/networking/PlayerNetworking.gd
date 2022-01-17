extends Node

export var puppet :bool

var processTime = 0
var updateProcess = 0.025

func _ready():
	GlobalNet.connect("playerNetworking",self,"_on_data")
	if !puppet:
		setName(GlobalVariables.username)

func _process(delta):
	if GlobalVariables.id and !puppet:
		processTime += delta
		var playerHasMoving = get_parent().velocity.z != 0 or get_parent().velocity.x != 0 or get_parent().y_velocity != -0.01
		if processTime > updateProcess and playerHasMoving : 
			sendPos() ; sendRot() ; 
			processTime = 0 

func _on_data(resp):
	match resp[0]:
		9:  setPing()
		6:  syncPos(resp)
		11: syncRot(resp)

func _on_Timer_timeout():
	GlobalVariables.lastPingTime = OS.get_ticks_msec()
	GlobalNet.sendPacket([8])

func sendPos():
	GlobalNet.sendPacket([5,GlobalVariables.id,get_parent().global_transform.origin])
	
func sendRot():
	GlobalNet.sendPacket([10,GlobalVariables.id,get_parent().get_node("Model").rotation])
	
func setName(name):
	get_parent().get_node("UserName/Viewport/Label").text = name

func setPing():
	var ping = str(OS.get_ticks_msec() - GlobalVariables.lastPingTime)
	get_parent().get_node("gui/ping").text = ping

func syncPos(resp):
	var player = getPlayerById(resp[1])
	if player:
		var _pos = resp[2].split(",")
		var pos = Vector3(float(_pos[0]),float(_pos[1]),float(_pos[2]))
		player.global_transform.origin = pos
		
func syncRot(resp):
	var player = getPlayerById(resp[1])
	if player and player.has_node("Model"):
		var model = player.get_node("Model")
		var _rot = resp[2].split(",") 
		var rot = Vector3(float(_rot[0]),float(_rot[1]),float(_rot[2])) 
		model.rotation = rot

func getPlayerById(id):
	var playerNodePath = str("MAP/otherPlayers/", str(id))
	for i in GlobalVariables.connectedPlayers:
		if i == str(id):
			return get_tree().current_scene.get_node(playerNodePath)
		else:
			return false
