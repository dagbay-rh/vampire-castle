extends Node

var wait_time = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible_ratio = 0
	$AnimationPlayer.play("show_text")
	$AnimationPlayer.connect("animation_finished", startTimer)
	
func change_to_main_scene():
	get_tree().change_scene_to_file("res://levels/castle/Castle.tscn")
	
func startTimer(anim_name):
	$Timer.start(wait_time)
	$Timer.connect("timeout", change_to_main_scene)
	
