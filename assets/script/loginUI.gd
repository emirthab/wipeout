extends Control

var demoscene = preload("res://assets/levels/Demo.tscn")

func _ready():
	$HTTPRequest.connect("request_completed",self,"_on_HTTPRequest_request_completed")
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


func _on_cancel_pressed():
	$"register-container".hide()


func _on_Label_meta_clicked(meta):
	match meta:
		"register" : $"register-container".show()




func _on_HTTPRequest_request_completed(result:int, response_code:int, headers:PoolStringArray, body:PoolByteArray):
	var pars = to_json(body)
	for par in pars:
		print(par)

func _on_Register_pressed():
	var usernameInput = $"register-container/container/login-container/inputs/usernameInput"
	var passInput1 = $"register-container/container/login-container/inputs/passwordInput"
	var passInput2 = $"register-container/container/login-container/inputs/passwordInput2"

	var data = {"name":"deneme","pass":"deneme"}
	var headers = ["Content-Type: application/json"]
	var query = JSON.print(data)
	$HTTPRequest.request(str(GlobalVariables.httpServer+"/register"),headers,false,HTTPClient.METHOD_POST,query)

	if usernameInput.text.length() > 3:
		if passInput1.text.length() > 7:
			if passInput1.text == passInput2.text :
				pass
				
				

