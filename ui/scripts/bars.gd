extends Control

@onready var special : TextureProgressBar = $Special
@onready var health : TextureProgressBar = $Health
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	special.connect("max_reached", _on_special_max_reached)
	PlayerState.connect("hurt", _on_player_take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_special_max_reached(_value):
	animation_player.play("special_ready")

func _on_player_take_damage(amount):
	health.value = health.value - amount
	# need to wire this up to death
	if health.value <= 0:
		print("game over, man")
