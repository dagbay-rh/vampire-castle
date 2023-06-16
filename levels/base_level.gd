extends Node

class_name Level

@export var is_playable : bool = false
@export var level_theme : AudioStream = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if level_theme:
		MusicPlayer.change_music_now(level_theme)
