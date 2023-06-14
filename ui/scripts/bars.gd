extends Control

@onready var special : ProgressBar = $Special
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	special.connect("max_reached", _on_special_max_reached)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_special_max_reached():
	animation_player.play("special_ready")
