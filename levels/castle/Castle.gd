extends Node2D

@export var is_playable : bool = true
@export var level_theme : AudioStream = null

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.change_music_now(level_theme)
	pass
