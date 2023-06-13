extends Node2D

var titleScreenPath = load("res://ui/TitleScreenBackground.tscn")
var current_scene = null
var mainScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	mainScene = get_node(".")
	var titleScreen = titleScreenPath.instantiate()
	mainScene.add_child(titleScreen)
	current_scene = mainScene.get_child(mainScene.get_child_count() - 1)
	
func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	mainScene.add_child(current_scene)
	mainScene.current_scene = current_scene
	
