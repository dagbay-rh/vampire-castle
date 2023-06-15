extends Node

var current_scene = null
var mainScene = null
var ui = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not has_node("/root/MainScene"):
		mainScene = get_tree().root
	else:
		mainScene = get_node("/root/MainScene")
		current_scene = mainScene.get_child(mainScene.get_child_count() - 1)
		ui = get_node("/root/MainScene/CanvasLayer")
		print_debug(ui)
		
func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	mainScene.add_child(current_scene)
	if current_scene.is_playable and ui != null:
		ui.visible = true
	else:
		ui.visible = false
	SceneSwitch.current_scene = current_scene
		
