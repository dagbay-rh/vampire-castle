extends Control

@onready var special : TextureProgressBar = $Special
@onready var health : TextureProgressBar = $Health
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# change_health is triggered by player state
	# using a signal in case bars are not available for the player state to read
	PlayerState.connect("change_health", _on_change_health)
	PlayerState.connect("increase_special", _on_increase_special)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_increase_special():
	print_debug("special_increased")
	special.value += 10
	if special.value == special.max_value:
		animation_player.play("special_ready")

func _on_change_health(new_health):
	health.value = new_health
