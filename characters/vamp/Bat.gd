extends CharacterBody2D

@export var move_speed : float = 100

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("bat_right") - Input.get_action_strength("bat_left"),
		Input.get_action_strength("bat_down") - Input.get_action_strength("bat_up")
	)
	print(input_direction)

	velocity = input_direction * move_speed
	
	move_and_slide()
