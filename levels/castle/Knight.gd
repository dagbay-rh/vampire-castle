extends CharacterBody2D


@onready var player = get_parent().get_node("Belmont")
const speed = 20

func _physics_process(delta):
	if player:
		var player_direction = (player.position - self.position).normalized()
		velocity = position.direction_to(player.position) * speed
		move_and_slide()
