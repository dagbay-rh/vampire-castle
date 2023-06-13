extends Control

class_name Transitioner

@onready var animation_color : ColorRect = $ColorRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_color.visible = false

func play_fade_out():
	animation_player.play("fade_out")
	
func play_fade_in():
	animation_player.play("fade_in")
