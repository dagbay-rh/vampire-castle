extends Control

func _on_new_game_pressed():
	SceneSwitch.switch_scene("res://levels/introduction.tscn")
	
func _on_load_game_pressed():
	# going to use load game to skip the cutscene for now
	SceneSwitch.switch_scene("res://levels/castle/Castle.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
