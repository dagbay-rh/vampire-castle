extends Control

func _on_new_game_pressed():
	SceneSwitch.switch_scene("res://levels/introduction.tscn")
	
func _on_load_game_pressed():
	pass
	
func _on_quit_pressed():
	get_tree().quit()
