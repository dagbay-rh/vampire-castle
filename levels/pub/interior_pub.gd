extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var belmont : AnimatedSprite2D = $Belmont/AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	var castle_theme : AudioStream = load("res://art/music/01 - DavidKBD - Belmont Chronicles Pack - Belmont Chronicles.ogg")
	await MusicPlayer.change_music_fade(castle_theme)
	SceneSwitch.switch_scene("res://levels/castle/Castle.tscn")

