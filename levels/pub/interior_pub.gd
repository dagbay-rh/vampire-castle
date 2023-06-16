extends Node2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var belmont : AnimatedSprite2D = $Belmont/AnimatedSprite2D

@export var is_playable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	SceneSwitch.switch_scene("res://levels/castle/Castle.tscn")

