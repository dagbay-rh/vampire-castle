extends Node


@onready var bg_music : AudioStreamPlayer = $BGMusic
@onready var music_fader : AnimationPlayer = $AnimationPlayer

@onready var title_bg_music : AudioStream = load("res://art/music/06 - DavidKBD - Belmont Chronicles Pack - Cathedral.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.set_stream(title_bg_music)
	if has_node("/root/MainScene"):
		bg_music.play()

func change_music_now(stream):
	bg_music.stop()
	bg_music.set_stream(stream)
	bg_music.play()

func change_music_fade(stream):
	fade_music_out()
	bg_music.set_stream(stream)
	bg_music.play()
	fade_music_in()
	
func fade_music_out():
	music_fader.play("fade_music")
	
func fade_music_in():
	music_fader.play_backwards("fade_music")
