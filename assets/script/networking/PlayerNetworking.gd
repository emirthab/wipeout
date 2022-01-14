extends Node

export var puppet :bool

var processTime = 0

func _ready():
	if !puppet:
		setName(GlobalVariables.username)

func setName(name):
	get_parent().get_node("UserName/Viewport/Label").text = name

func _process(delta):
	if GlobalVariables.id and !puppet:
		processTime += delta
		var playerHasMoving = get_parent().velocity.z != 0 or get_parent().velocity.x != 0 or get_parent().y_velocity != -0.01
		if processTime > 0.025 and playerHasMoving:
			GlobalNet.sendPacket([5,GlobalVariables.id,get_parent().global_transform.origin])
			GlobalNet.sendPacket([10,GlobalVariables.id,get_parent().get_node("Model").rotation])
			processTime = 0 

func _on_Timer_timeout():
	GlobalVariables.lastPingTime = OS.get_ticks_msec()
	GlobalNet.sendPacket([8])

func setPing():
	var ping = str(OS.get_ticks_msec() - GlobalVariables.lastPingTime)
	get_parent().get_node("gui/ping").text = ping
