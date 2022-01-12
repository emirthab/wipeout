extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$main/twitch_button.connect("pressed",self,"_on_twitch_pressed")




func _on_discord_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")
	


func _on_play_pressed():
	pass # Replace with function body.


func _on_twitch_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")
	print("deneme")
