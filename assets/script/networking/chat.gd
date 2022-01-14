extends Node

onready var chatInput = get_node("ChatInput")
var textt = """[b][color=#afa]emirthab : [/color][/b] merhaba deneme deneme lorem ipsuma asdas deneme yazı
[img=16x16]res://assets/ui/chat-icons/crovn-5.png[/img] [b][color=#afa]asetilen : [/color][/b] merhaba deneme deneme lorem 
[b][color=#afa]emirthab : [/color][/b] merhaba deneme deneme lorem ipsuma asdas deneme yazı
[b][color=#afa]asetilen : [/color][/b] merhaba deneme deneme lorem 
[b][color=#afa]asetilen : [/color][/b] merhaba deneme deneme lorem  """

func _ready():
	for child in chatInput.get_children():
		if child is VScrollBar:
			remove_child(child)
		elif child is HScrollBar:
			remove_child(child)


func _on_ChatInput_focus_entered():
	pass

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_ENTER) and just_pressed:
		if chatInput.has_focus():
			chatInput.release_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if chatInput.text != "":
				GlobalNet.sendPacket([12,GlobalVariables.id,str('"',chatInput.text,'"')])
				chatInput.text = ""
		else:
			chatInput.grab_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			
