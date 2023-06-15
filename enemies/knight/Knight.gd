extends CharacterBody2D


@onready var player = get_parent().get_node("Belmont")
const speed = 30

func _physics_process(delta):
	if player:
		var player_direction = (player.position - self.position).normalized()
		velocity = position.direction_to(player.position) * speed
		print(player_direction.x)
		if player_direction.x < 0:
			$Sprite2D.flip_h = true
		if player_direction.x > 0:
			$Sprite2D.flip_h = false
		move_and_slide()
