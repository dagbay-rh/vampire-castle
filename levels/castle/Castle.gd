extends Node2D

@export var is_playable : bool = true
@export var level_music : AudioStream = load("res://art/music/01 - DavidKBD - Belmont Chronicles Pack - Belmont Chronicles.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.change_music_now(level_music)

