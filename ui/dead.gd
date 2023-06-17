extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	if SceneSwitch.current_scene == null:
		var this_scene = get_node(".")
		SceneSwitch.current_scene = this_scene
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	SceneSwitch.switch_scene("res://levels/jail/Jail.tscn")
	get_tree().paused = false


func _on_button_2_pressed():
	get_tree().quit()
