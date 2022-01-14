extends Control

var demoscene = preload("res://assets/levels/Demo.tscn")

func _ready():
	$main/twitch_button.connect("pressed",self,"_on_twitch_pressed")


func _on_discord_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")
	

func _on_play_pressed():
	GlobalVariables.username = $"login-container/inputs/usernameInput".text
	GlobalNet.Connect()
	self.hide()
	#TODO : pass control on database
	add_child(demoscene.instance())
	


func _on_twitch_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")
