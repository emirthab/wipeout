extends Node

export var puppet :bool

func _ready():
	if !puppet:
		setName(GlobalVariables.username)

func setName(name):
	get_parent().get_node("UserName/Viewport/Label").text = name

func _process(delta):
	if GlobalVariables.id and !puppet:
		GlobalNet.sendPacket([5,GlobalVariables.id,get_parent().global_transform.origin])

func _on_Timer_timeout():
	GlobalVariables.lastPingTime = OS.get_ticks_msec()
	GlobalNet.sendPacket([8])

func setPing():
	var ping = str(OS.get_ticks_msec() - GlobalVariables.lastPingTime)
	get_parent().get_node("gui/ping").text = ping