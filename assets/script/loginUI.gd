extends Control

onready var errorLabelReg = $"register-container/container/login-container/error"
onready var errorLabelLog = $"login-container/error"

var demoscene = preload("res://assets/levels/Demo.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$HTTPRequestRegister.connect("request_completed",self,"_on_HTTPRequestRegister_request_completed")
	$HTTPRequestLogin.connect("request_completed",self,"_on_HTTPRequestLogin_request_completed")
	$main/twitch_button.connect("pressed",self,"_on_twitch_pressed")

func _on_discord_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")
	

func _on_play_pressed():
	var usernameInput = $"login-container/inputs/usernameInput"
	var passInput = $"login-container/inputs/passwordInput"

	var data = {"name":str(usernameInput.text),"pass":str(passInput.text)}
	var headers = ["Content-Type: application/json"]
	var query = JSON.print(data)

	$HTTPRequestLogin.request(str(GlobalVariables.httpServer+"/login"),headers,false,HTTPClient.METHOD_POST,query)
	
func _on_twitch_pressed():
	OS.shell_open("https://www.twitch.tv/emirthab")


func _on_cancel_pressed():
	$"register-container".hide()


func _on_Label_meta_clicked(meta):
	match meta:
		"register" : $"register-container".show()

func _on_HTTPRequestLogin_request_completed(result:int, response_code:int, headers:PoolStringArray, body:PoolByteArray):
	var resp = JSON.parse(body.get_string_from_utf8()).result
	print(resp)
	if resp["response"] == "OK":
		GlobalVariables.websocketToken = resp["token"]
		GlobalVariables.username = $"login-container/inputs/usernameInput".text
		GlobalNet.Connect()
		self.hide()
		add_child(demoscene.instance())
	else:
		$"login-container/error".show()
		$"login-container/error".text = resp["response"]

func _on_HTTPRequestRegister_request_completed(result:int, response_code:int, headers:PoolStringArray, body:PoolByteArray):
	var resp = JSON.parse(body.get_string_from_utf8()).result
	if resp["response"] == "OK":
		print(resp["dc_code"])
	else:
		print(resp["response"])
		errorLabelReg.show()
		errorLabelReg.text = resp["response"]

func _on_Register_pressed():
	var usernameInput = $"register-container/container/login-container/inputs/usernameInput"
	var passInput1 = $"register-container/container/login-container/inputs/passwordInput"
	var passInput2 = $"register-container/container/login-container/inputs/passwordInput2"

	var data = {"name":str(usernameInput.text),"pass":str(passInput1.text)}
	var headers = ["Content-Type: application/json"]
	var query = JSON.print(data)
	
	if passInput1.text == passInput2.text :
		$HTTPRequestRegister.request(str(GlobalVariables.httpServer+"/register"),headers,false,HTTPClient.METHOD_POST,query)
	else:
		errorLabelReg.show()
		errorLabelReg.text = "İki şifre aynı olmalı."

