extends CharacterBody2D

@export var move_speed : float = 100

func _physics_process(_delta):
	var input_direction = Vector2(
		
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	print(input_direction)

	velocity = input_direction * move_speed
	gravity += 30
	if Input.is_action_just_pressed("space"):   
	   direction.y = -700
	direction.y = gravity
	move_and_slide(direction, Vector2.UP)
