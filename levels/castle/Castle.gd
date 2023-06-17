extends Level

func _process(delta):
	pass


func _on_outer_bedroom_door_body_entered(body):
	print(body.name + " entered village transition area")
	if body.name == "Belmont":
		# hacky way to be able to run this scene alone for testing
		# when playing game, current_scene won't be nil
		if SceneSwitch.current_scene == null:
			var this_scene = get_node(".")
			SceneSwitch.current_scene = this_scene
			
		$AnimationPlayer.queue("fade_scene") # would be dope to have a player input and animation of climbing ladder happen here instead
		PlayerState.player_node.pause_input = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_scene":
		PlayerState.player_node.pause_input = false
		SceneSwitch.switch_scene("res://levels/BelmontBedroom/belmont_bedroom.tscn")
