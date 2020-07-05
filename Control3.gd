extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _input(event):
	if event.is_action_pressed("quit") and not event.is_echo():
		get_tree().quit()

func _on_Button_pressed():
	get_tree().change_scene("res://mainmenu.tscn")
