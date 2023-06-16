extends Level

var belmont : Node2D = null

func _on_area_2d_ladder_body_entered(body):
	print(body.name + " entered village transition area")
	if body.name == "Belmont":
		# hacky way to be able to run this scene alone for testing
		# when playing game, current_scene won't be nil
		if SceneSwitch.current_scene == null:
			var this_scene = get_node(".")
			SceneSwitch.current_scene = this_scene
			
		$AnimationPlayer.play("show_text")
		$AnimationPlayer.queue("fade_scene") # would be dope to have a player input and animation of climbing ladder happen here instead
		belmont.pause_input = true

func _on_label_ready():
	$Label.visible_ratio = 0


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_scene":
		belmont.pause_input = false
		SceneSwitch.switch_scene("res://levels/castle/Castle.tscn")


func _on_ready():
	belmont = get_node("./Belmont")
