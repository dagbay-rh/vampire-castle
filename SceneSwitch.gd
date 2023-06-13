extends Node

var current_scene = null
var mainScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_node("/root/MainScene"):
		pass
	else:
		mainScene = get_node("/root/MainScene")
		current_scene = mainScene.get_child(mainScene.get_child_count() - 1)
	
func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	mainScene.add_child(current_scene)
	SceneSwitch.current_scene = current_scene
