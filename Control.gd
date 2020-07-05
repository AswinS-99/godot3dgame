extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$mainmenumusic.play()
func _input(event):
	if event.is_action_pressed("quit") and not event.is_echo():
		get_tree().quit()

func _on_playbutton_pressed():

	get_tree().change_scene("res://world.tscn")

func _on_helpbutton_pressed():
	get_tree().change_scene("res://help.tscn")

func _on_exitbutton_pressed():
	get_tree().quit()




