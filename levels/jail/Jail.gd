extends Level

func _on_area_2d_body_entered(body):
	print(body.name + " entered sewer transition area")
	if body.name == "Belmont":
		# hacky way to be able to run this scene alone for testing
		# when playing game, current_scene won't be nil
		if SceneSwitch.current_scene == null:
			var this_scene = get_node(".")
			SceneSwitch.current_scene = this_scene
		
		SceneSwitch.switch_scene("res://levels/sewer/Sewer.tscn")
